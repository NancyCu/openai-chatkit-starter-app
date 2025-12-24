"""FastAPI entrypoint for the ChatKit starter backend."""

from __future__ import annotations

import asyncio
import json
import logging
import os
from typing import Any, Dict

from openai import OpenAI
from chatkit.server import StreamingResult
from fastapi import Body, FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse, Response, StreamingResponse

from .server import StarterChatServer
from .workbook import generate_rent_workbook

logger = logging.getLogger(__name__)
openai_client = OpenAI()
MAIN_VECTOR_STORE_ID = os.environ.get("MAIN_VECTOR_STORE_ID")

REQUIRED_PROPERTY_IDS = [f"KN{index:02d}" for index in range(1, 11)]

RENT_WORKBOOK_ROW_SCHEMA: Dict[str, Any] = {
    "type": "object",
    "properties": {
        "month_number": {"type": "integer", "minimum": 1, "maximum": 12},
        "month": {"type": "string"},
        "rent_due": {"type": "number"},
        "housing_dept": {"type": ["string", "null"]},
        "housing_paid": {"type": "number"},
        "tenant_paid": {"type": "number"},
        "total_received": {"type": "number"},
        "month_balance_due": {"type": "number"},
        "year_balance_due": {"type": "number"},
        "remarks": {"type": "string"},
    },
    "required": [
        "month_number",
        "month",
        "rent_due",
        "housing_dept",
        "housing_paid",
        "tenant_paid",
        "total_received",
        "month_balance_due",
        "year_balance_due",
        "remarks",
    ],
    "additionalProperties": False,
}

RENT_WORKBOOK_PROPERTY_SCHEMA: Dict[str, Any] = {
    "type": "object",
    "properties": {
        "property_id": {"type": "string", "enum": REQUIRED_PROPERTY_IDS},
        "property_address": {"type": ["string", "null"]},
        "tenant_name": {"type": ["string", "null"]},
        "period_months": {"type": "integer", "const": 12},
        "rows": {
            "type": "array",
            "minItems": 12,
            "maxItems": 12,
            "items": RENT_WORKBOOK_ROW_SCHEMA,
        },
    },
    "required": ["property_id", "rows", "period_months"],
    "additionalProperties": False,
}

RENT_WORKBOOK_SCHEMA: Dict[str, Any] = {
    "type": "object",
    "properties": {
        "template_version": {"type": "string", "const": "property_rents_received_v1"},
        "year": {"type": "integer", "const": 2025},
        "properties": {
            "type": "array",
            "minItems": len(REQUIRED_PROPERTY_IDS),
            "maxItems": len(REQUIRED_PROPERTY_IDS),
            "items": RENT_WORKBOOK_PROPERTY_SCHEMA,
        },
    },
    "required": ["template_version", "year", "properties"],
    "additionalProperties": False,
}

RENT_WORKBOOK_TEXT_FORMAT: Dict[str, Any] = {
    "format": {
        "type": "json_schema",
        "name": "rent_workbook_payload",
        "schema": RENT_WORKBOOK_SCHEMA,
        "description": "Strict rent workbook payload (2025) covering KN01-KN10 with 12 rows per property.",
        "strict": True,
    }
}

VECTOR_FETCH_INSTRUCTIONS = (
    "You are the RentWorkbookAgent. Use the file_search tool to open RENT_Payments_2025.txt"
    " and return STRICT JSON only: template_version property_rents_received_v1, year 2025, and properties"
    " KN01..KN10, each with 12 rows for months 1..12. Field mapping must match the RentWorkbookAgent mapping"
    " (scheduled_rent_amount->rent_due, property_address->property_address, tenant_name->tenant_name, housing_dept->housing_dept,"
    " housing_paid->housing_paid, tenant_paid->tenant_paid, total_received->total_received, month_balance_due->month_balance_due,"
    " year_balance_due->year_balance_due, remarks->remarks). Map any differently named columns to the schema fields, keep rows in month order,"
    " and when data is missing keep the row while setting numeric fields to 0 and remarks to 'Missing data'. No markdown, only the JSON payload."
)

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


def _payload_needs_vector_data(payload: dict[str, Any]) -> bool:
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


async def _fetch_rent_payload_from_vector_store() -> dict[str, Any]:
    if not MAIN_VECTOR_STORE_ID:
        raise RuntimeError("MAIN_VECTOR_STORE_ID is not configured")
    file_search_tool = {
        "type": "file_search",
        "vector_store_ids": [MAIN_VECTOR_STORE_ID],
        "max_num_results": 5,
    }

    def _call_responses() -> Any:
        return openai_client.responses.create(
            model="gpt-5.1-mini",
            instructions=VECTOR_FETCH_INSTRUCTIONS,
            input="Use the file_search tool to locate RENT_Payments_2025.txt and build the rent workbook payload.",
            tools=[file_search_tool],
            tool_choice={"type": "file_search"},
            max_tool_calls=1,
            include=["file_search_call.results"],
            temperature=0.0,
            text=RENT_WORKBOOK_TEXT_FORMAT,
        )

    response = await asyncio.to_thread(_call_responses)
    file_search_items = [
        item for item in response.output if getattr(item, "type", "") == "file_search_call"
    ]
    result_count = sum(len(item.results or []) for item in file_search_items)
    logger.info("Vector store fetch succeeded (file_search results=%d)", result_count)

    text_output = response.output_text.strip()
    if not text_output:
        raise ValueError("Vector store response did not contain output text")
    try:
        payload = json.loads(text_output)
    except json.JSONDecodeError as exc:
        raise ValueError("Vector store response is not valid JSON") from exc
    if not isinstance(payload, dict):
        raise ValueError("Vector store response must be a JSON object")
    return payload


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
    used_vector_payload = False
    if _payload_needs_vector_data(payload):
        logger.info("Payload missing data; fetching RENT_Payments_2025 from vector store")
        try:
            final_payload = await _fetch_rent_payload_from_vector_store()
        except Exception as exc:
            logger.exception("Vector store fetch failed")
            raise HTTPException(status_code=502, detail="Failed to load rent workbook data") from exc
        used_vector_payload = True

    try:
        _validate_rent_payload(final_payload, "vector store" if used_vector_payload else "client payload")
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

