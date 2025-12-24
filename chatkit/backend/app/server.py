"""ChatKit server that streams responses from a single assistant."""

from __future__ import annotations

import os

from typing import Any, AsyncIterator
import logging

logger = logging.getLogger(__name__)

from agents import Runner
from chatkit.agents import AgentContext, simple_to_agent_input, stream_agent_response
from chatkit.server import ChatKitServer
from chatkit.types import ThreadMetadata, ThreadStreamEvent, UserMessageItem

from .memory_store import MemoryStore
from agents import Agent


MAX_RECENT_ITEMS = 30
MODEL = "gpt-4.1-mini"
DEFAULT_WORKFLOW_VERSION = os.environ.get("OPENAI_WORKFLOW_VERSION", "draft")


assistant_agent = Agent[AgentContext[dict[str, Any]]](
    model=MODEL,
    name="Starter Assistant",
    instructions=(
        "You are a concise, helpful assistant. "
        "Keep replies short and focus on directly answering "
        "the user's request."
    ),
)

rent_workbook_agent = Agent[AgentContext[dict[str, Any]]](
    model=MODEL,
    name="RentWorkbookAgent",
    instructions=(
        "You are the RentWorkbookAgent. "
        "If the user asks to generate/export/create the 2025 rent workbook (e.g., 'generate 2025 rent workbook'), you MUST respond with ONLY a single valid JSON object and nothing else. "
        "Do NOT ask clarifying questions. Do NOT include markdown. "
        "JSON schema (must match exactly): "
        "{\"template_version\":\"property_rents_received_v1\",\"year\":2025,\"properties\":[{\"property_id\":\"KN01\",\"property_address\":null,\"tenant_name\":null,\"period_months\":12,\"rows\":[{\"month_number\":1,\"month\":\"Jan\",\"rent_due\":0,\"housing_dept\":null,\"housing_paid\":0,\"tenant_paid\":0,\"total_received\":0,\"month_balance_due\":0,\"year_balance_due\":0,\"remarks\":\"\"}]}]}. "
        "Requirements: include KN01..KN10; each has exactly 12 rows for months 1..12 in order; total rows 120. "
        "If data is missing, keep the row and set numeric fields to 0 and remarks to 'Missing data'."
    ),
)


class StarterChatServer(ChatKitServer[dict[str, Any]]):
    """Server implementation that keeps conversation state in memory."""

    def __init__(self) -> None:
        self.store: MemoryStore = MemoryStore()
        super().__init__(self.store)

    async def respond(
        self,
        thread: ThreadMetadata,
        item: UserMessageItem | None,
        context: dict[str, Any],
    ) -> AsyncIterator[ThreadStreamEvent]:
        items_page = await self.store.load_thread_items(
            thread.id,
            after=None,
            limit=MAX_RECENT_ITEMS,
            order="desc",
            context=context,
        )
        items = list(reversed(items_page.data))
        agent_input = await simple_to_agent_input(items)

        agent_context = AgentContext(
            thread=thread,
            store=self.store,
            request_context=context,
        )

        # Workflow routing: confirm the values are present and pass them via trace metadata.
        workflow_id = context.get("workflow_id")
        workflow_version = context.get("workflow_version") or DEFAULT_WORKFLOW_VERSION
        logger.info("ChatKit request workflow_id=%s workflow_version=%s", workflow_id, workflow_version)

        trace_metadata: dict[str, Any] = {}
        if workflow_id:
            trace_metadata["workflow_id"] = workflow_id
            trace_metadata["workflow_version"] = workflow_version

        # Route workbook requests to the dedicated agent so it never asks clarifying questions.
        user_text = ""
        if item is not None:
            user_text = (
                getattr(item, "text", "")
                or getattr(item, "content", "")
                or ""
            )
        user_text_l = str(user_text).lower()
        use_rent_workbook_agent = (
            "2025 rent workbook" in user_text_l
            or "generate 2025 rent workbook" in user_text_l
            or "export 2025 rent workbook" in user_text_l
            or "create 2025 rent workbook" in user_text_l
        )

        selected_agent = rent_workbook_agent if use_rent_workbook_agent else assistant_agent

        # Run the default agent, but include trace metadata so the platform can route to the workflow.
        # If this SDK version doesn't accept trace_metadata, fall back cleanly.
        try:
            result = Runner.run_streamed(
                selected_agent,
                agent_input,
                context=agent_context,
                trace_metadata=trace_metadata or None,
            )
        except TypeError:
            result = Runner.run_streamed(
                selected_agent,
                agent_input,
                context=agent_context,
            )

        async for event in stream_agent_response(agent_context, result):
            yield event
