"""FastAPI entrypoint for the ChatKit starter backend."""

from __future__ import annotations

from typing import Any

import logging
import os
from calendar import month_abbr
from csv import DictReader
from pathlib import Path

from fastapi import Body, FastAPI, HTTPException, Request, Response
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse, JSONResponse, StreamingResponse
from fastapi.staticfiles import StaticFiles

from chatkit.server import StreamingResult

from .server import StarterChatServer
from .workbook import generate_rent_workbook

logger = logging.getLogger(__name__)

REQUIRED_PROPERTY_IDS = [f"KN{index:02d}" for index in range(1, 11)]
DATA_DIR = Path(__file__).resolve().parents[1] / "data"
RENT_PAYMENTS_FILE_TEMPLATE = "RENT_Payments_{year}.txt"
MONTH_NAMES = {index: month_abbr[index] for index in range(1, 13)}
MISSING_DATA_REMARKS = "Missing data"

app = FastAPI(title="ChatKit Starter API")


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

WORKFLOW_ID = os.environ.get("OPENAI_WORKFLOW_ID")
WORKFLOW_VERSION = os.environ.get("OPENAI_WORKFLOW_VERSION", "draft")

chatkit_server = StarterChatServer()


def _payload_needs_local_data(payload: dict[str, Any]) -> bool:
    properties = payload.get("properties")
    if not isinstance(properties, list):
        return True
    if len(properties) < len(REQUIRED_PROPERTY_IDS):
        return True
    for prop in properties:
        if not isinstance(prop, dict):
            return True
        rows = prop.get("rows")
        if not isinstance(rows, list) or len(rows) < 12:
            return True
        for row in rows:
            remarks = row.get("remarks")
            if isinstance(remarks, str) and remarks.strip().lower() == "missing data":
                return True
    return False


def _validate_rent_payload(payload: dict[str, Any], context: str) -> None:
    try:
        if payload.get("template_version") != "property_rents_received_v1":
            raise ValueError("template_version must be property_rents_received_v1")
        if payload.get("year") != 2025:
            raise ValueError("year must be 2025")
        properties = payload.get("properties")
        if not isinstance(properties, list):
            raise ValueError("properties must be an array")
        if len(properties) != len(REQUIRED_PROPERTY_IDS):
            raise ValueError("properties must include KN01-KN10")

        seen_ids: set[str] = set()
        for prop in properties:
            if not isinstance(prop, dict):
                raise ValueError("each property must be an object")
            property_id = prop.get("property_id")
            if property_id not in REQUIRED_PROPERTY_IDS:
                raise ValueError("invalid or missing property_id")
            if property_id in seen_ids:
                raise ValueError("duplicate property_id found")
            seen_ids.add(property_id)

            if prop.get("period_months") != 12:
                raise ValueError(f"{property_id} must have period_months 12")
            for field in ("property_address", "tenant_name"):
                value = prop.get(field)
                if value is not None and not isinstance(value, str):
                    raise ValueError(f"{field} must be a string or null for {property_id}")

            rows = prop.get("rows")
            if not isinstance(rows, list):
                raise ValueError(f"{property_id} rows must be a list")
            if len(rows) != 12:
                raise ValueError(f"{property_id} must have exactly 12 rows")

            seen_months: set[int] = set()
            for row in rows:
                if not isinstance(row, dict):
                    raise ValueError("each row must be an object")
                month_number = row.get("month_number")
                if not isinstance(month_number, int) or not 1 <= month_number <= 12:
                    raise ValueError("month_number must be an integer between 1 and 12")
                if month_number in seen_months:
                    raise ValueError("duplicate month_number detected")
                seen_months.add(month_number)

                if not isinstance(row.get("month"), str):
                    raise ValueError("month must be a string")
                housing_dept = row.get("housing_dept")
                if housing_dept is not None and not isinstance(housing_dept, str):
                    raise ValueError("housing_dept must be a string or null")

                numeric_fields = (
                    "rent_due",
                    "housing_paid",
                    "tenant_paid",
                    "total_received",
                    "month_balance_due",
                    "year_balance_due",
                )
                for numeric_field in numeric_fields:
                    value = row.get(numeric_field)
                    if not isinstance(value, (int, float)):
                        raise ValueError(f"{numeric_field} must be a number")

                if not isinstance(row.get("remarks"), str):
                    raise ValueError("remarks must be a string")

            if seen_months != set(range(1, 13)):
                raise ValueError("rows must cover months 1 through 12")
    except ValueError as exc:
        logger.error("Payload validation failed (%s): %s", context, exc)
        raise
    logger.info("Payload validation succeeded (%s)", context)


def _parse_numeric_value(value: str | None, *, field: str, context: str) -> float:
    raw = value or ""
    cleaned = raw.strip().replace("$", "").replace(",", "")
    if not cleaned:
        return 0.0
    try:
        return float(cleaned)
    except ValueError as exc:
        raise ValueError(f"{context}: {field} is not a number ({value})") from exc


def build_payload_from_local_tsv(year: int = 2025) -> dict[str, Any]:
    file_path = DATA_DIR / RENT_PAYMENTS_FILE_TEMPLATE.format(year=year)
    if not file_path.is_file():
        raise FileNotFoundError(f"Missing data file: {file_path}")

    property_rows: dict[str, dict] = {
        prop_id: {
            "property_address": None,
            "tenant_name": None,
            "rows": {},
        }
        for prop_id in REQUIRED_PROPERTY_IDS
    }

    with file_path.open(encoding="utf-8") as source:
        reader = DictReader(source, delimiter="\t")
        for row in reader:
            property_id = (row.get("property_id") or "").strip()
            if not property_id or property_id not in property_rows:
                logger.debug("Skipping unsupported property_id=%s", property_id)
                continue
            month_number_raw = row.get("month_number")
            try:
                month_number = int(month_number_raw or "")
            except ValueError:
                logger.warning(
                    "Skipping %s row with invalid month_number=%r",
                    property_id,
                    month_number_raw,
                )
                continue
            if not 1 <= month_number <= 12:
                logger.warning(
                    "Skipping %s row with out-of-range month_number=%d",
                    property_id,
                    month_number,
                )
                continue

            entry = property_rows[property_id]
            address = (row.get("property_address") or "").strip()
            if address:
                entry["property_address"] = address
            tenant = (row.get("tenant_name") or "").strip()
            if tenant:
                entry["tenant_name"] = tenant

            month_rows = entry["rows"]
            if month_number in month_rows:
                logger.warning(
                    "Duplicate data for %s month %d; keeping first row",
                    property_id,
                    month_number,
                )
                continue

            month_name = (row.get("month_name") or MONTH_NAMES.get(month_number, "")).strip()
            month_rows[month_number] = {
                "month_number": month_number,
                "month": month_name or MONTH_NAMES[month_number],
                "rent_due": _parse_numeric_value(
                    row.get("scheduled_rent_amount"),
                    field="scheduled_rent_amount",
                    context=f"{property_id} month {month_number}",
                ),
                "housing_dept": (
                    (row.get("housing_dept_name") or row.get("housing_dept") or "").strip()
                    or MISSING_DATA_REMARKS
                ),
                "housing_paid": _parse_numeric_value(
                    row.get("housing_amount_paid"),
                    field="housing_amount_paid",
                    context=f"{property_id} month {month_number}",
                ),
                "tenant_paid": _parse_numeric_value(
                    row.get("tenant_amount_paid"),
                    field="tenant_amount_paid",
                    context=f"{property_id} month {month_number}",
                ),
                "total_received": _parse_numeric_value(
                    row.get("total_amount_received"),
                    field="total_amount_received",
                    context=f"{property_id} month {month_number}",
                ),
                "month_balance_due": _parse_numeric_value(
                    row.get("month_balance_due"),
                    field="month_balance_due",
                    context=f"{property_id} month {month_number}",
                ),
                "year_balance_due": _parse_numeric_value(
                    row.get("year_balance_due"),
                    field="year_balance_due",
                    context=f"{property_id} month {month_number}",
                ),
                "remarks": (row.get("notes") or "").strip(),
            }

    properties: list[dict[str, Any]] = []
    for property_id in REQUIRED_PROPERTY_IDS:
        entry = property_rows[property_id]
        rows = []
        for month_number in range(1, 13):
            month_entry = entry["rows"].get(month_number)
            if month_entry is None:
                month_entry = {
                    "month_number": month_number,
                    "month": MONTH_NAMES[month_number],
                    "rent_due": 0.0,
                    "housing_dept": MISSING_DATA_REMARKS,
                    "housing_paid": 0.0,
                    "tenant_paid": 0.0,
                    "total_received": 0.0,
                    "month_balance_due": 0.0,
                    "year_balance_due": 0.0,
                    "remarks": MISSING_DATA_REMARKS,
                }
            rows.append(month_entry)

        properties.append(
            {
                "property_id": property_id,
                "property_address": entry["property_address"] or MISSING_DATA_REMARKS,
                "tenant_name": entry["tenant_name"] or MISSING_DATA_REMARKS,
                "period_months": 12,
                "rows": rows,
            }
        )

    logger.info("Rebuilt rent payload from %s", file_path)
    return {
        "template_version": "property_rents_received_v1",
        "year": year,
        "properties": properties,
    }


@app.post("/chatkit")
async def chatkit_endpoint(request: Request) -> Response:
    """Proxy the ChatKit web component payload to the server implementation."""
    payload = await request.body()
    result = await chatkit_server.process(
        payload,
        {
            "request": request,
            "workflow_id": WORKFLOW_ID,
            "workflow_version": WORKFLOW_VERSION,
        },
    )

    if isinstance(result, StreamingResult):
        return StreamingResponse(result, media_type="text/event-stream")
    if hasattr(result, "json"):
        return Response(content=result.json, media_type="application/json")
    return JSONResponse(result)


@app.post("/api/rent-workbook")
async def rent_workbook_endpoint(payload: dict = Body(...)) -> Response:
    """Generate a rent workbook and return it as a binary download."""

    final_payload = payload
    rebuilt_from_local = False
    if _payload_needs_local_data(payload):
        logger.info("Payload missing data; rebuilding from local TSV")
        try:
            final_payload = build_payload_from_local_tsv()
        except FileNotFoundError as exc:
            logger.exception("Local rent data file missing")
            raise HTTPException(status_code=500, detail=str(exc)) from exc
        except ValueError as exc:
            logger.exception("Local rent data parsing failed")
            raise HTTPException(status_code=500, detail=f"Local data error: {exc}") from exc
        rebuilt_from_local = True

    context = "local TSV" if rebuilt_from_local else "client payload"
    try:
        _validate_rent_payload(final_payload, context)
        excel_bytes = generate_rent_workbook(final_payload)
    except FileNotFoundError as exc:
        raise HTTPException(status_code=500, detail=str(exc))
    except ValueError as exc:
        raise HTTPException(status_code=400, detail=str(exc))
    except Exception as exc:  # pragma: no cover - fail-safe
        raise HTTPException(status_code=500, detail=f"Workbook generation failed: {exc}")

    year = final_payload.get("year", 2025)
    filename = f"Rent_Workbook_{year}.xlsx"
    headers = {
        "Content-Disposition": f'attachment; filename="{filename}"',
    }

    return Response(
        content=excel_bytes,
        media_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        headers=headers,
    )


# ---- Serve built frontend (SPA) without intercepting POST /api/* ----
STATIC_DIR = Path(__file__).parent / "static"
ASSETS_DIR = STATIC_DIR / "assets"
INDEX_FILE = STATIC_DIR / "index.html"

# Vite build references /assets/* by default
if ASSETS_DIR.is_dir():
    app.mount("/assets", StaticFiles(directory=str(ASSETS_DIR)), name="assets")


@app.get("/")
def spa_root() -> Response:
    if INDEX_FILE.is_file():
        return FileResponse(str(INDEX_FILE))
    raise HTTPException(status_code=404, detail="Frontend not built")


@app.get("/{full_path:path}")
def spa_fallback(full_path: str) -> Response:
    # Never hijack API/docs routes
    if full_path.startswith("api/") or full_path.startswith("chatkit") or full_path.startswith("docs") or full_path.startswith("openapi") or full_path.startswith("redoc"):
        raise HTTPException(status_code=404, detail="Not found")

    if INDEX_FILE.is_file():
        return FileResponse(str(INDEX_FILE))
    raise HTTPException(status_code=404, detail="Frontend not built")
