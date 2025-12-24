"""FastAPI entrypoint for the ChatKit starter backend."""

from __future__ import annotations

import os

from chatkit.server import StreamingResult
from fastapi import Body, FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse, Response, StreamingResponse

from .server import StarterChatServer
from .workbook import generate_rent_workbook

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

    try:
        excel_bytes = generate_rent_workbook(payload)
    except FileNotFoundError as exc:
        raise HTTPException(status_code=500, detail=str(exc))
    except ValueError as exc:
        raise HTTPException(status_code=400, detail=str(exc))
    except Exception as exc:  # pragma: no cover - fail-safe
        raise HTTPException(status_code=500, detail=f"Workbook generation failed: {exc}")

    year = payload.get("year", 2025)
    filename = f"Rent_Workbook_{year}.xlsx"
    headers = {
        "Content-Disposition": f'attachment; filename="{filename}"',
    }

    return Response(
        content=excel_bytes,
        media_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        headers=headers,
    )

