# ChatKit Starter

Minimal Vite + React UI paired with a FastAPI backend that forwards chat
requests to OpenAI through the ChatKit server library.

## Quick start

```bash
npm install
npm run dev
```

What happens:

- `npm run dev` starts the FastAPI backend on `127.0.0.1:8000` and the Vite
  frontend on `127.0.0.1:3000` with a proxy at `/chatkit`.

## Required environment

- `OPENAI_API_KEY` (backend)
- `VITE_CHATKIT_API_URL` (optional, defaults to `/chatkit`)
- `VITE_CHATKIT_API_DOMAIN_KEY` (optional, defaults to `domain_pk_localhost_dev`)

Set `OPENAI_API_KEY` in your shell or in `.env.local` at the repo root before
running the backend. Register a production domain key in the OpenAI dashboard
and set `VITE_CHATKIT_API_DOMAIN_KEY` when deploying.

## Frontend environment setup

Create `frontend/.env` (or `frontend/.env.local`) with these placeholders and
replace them with your real values before building the frontend:

```bash
VITE_CHATKIT_API_DOMAIN_KEY=domain_pk_your_domain_key_here
VITE_CHATKIT_API_URL=/chatkit
```

> Note: `OPENAI_API_KEY` must **never** be placed in the frontend. Keep it in
> `.env.local` at the repo root (backend only).

## Customize

- Update UI and connection settings in `frontend/src/lib/config.ts`.
- Adjust layout in `frontend/src/components/ChatKitPanel.tsx`.
- Swap the in-memory store in `backend/app/server.py` for persistence.

## Testing the Rent Workbook API

The backend includes an endpoint to generate Excel workbooks from property rent data.

**Endpoint:** `POST http://127.0.0.1:8000/api/rent-workbook`

**Sample test (minimal):**

```bash
curl -X POST http://127.0.0.1:8000/api/rent-workbook \
  -H "Content-Type: application/json" \
  -d '{
    "template_version": "property_rents_received_v1",
    "year": 2025,
    "properties": [
      {
        "property_id": "KN01",
        "property_address": "123 Main St",
        "tenant_name": "John Doe",
        "period_months": 12,
        "rows": [
          {
            "month_number": 1,
            "month": "Jan",
            "rent_due": 1000,
            "housing_dept": null,
            "housing_paid": 0,
            "tenant_paid": 1000,
            "total_received": 1000,
            "month_balance_due": 0,
            "year_balance_due": 0,
            "remarks": ""
          },
          {
            "month_number": 2,
            "month": "Feb",
            "rent_due": 1000,
            "housing_dept": null,
            "housing_paid": 0,
            "tenant_paid": 1000,
            "total_received": 1000,
            "month_balance_due": 0,
            "year_balance_due": 0,
            "remarks": ""
          }
        ]
      }
    ]
  }' \
  --output Rent_Workbook_2025.xlsx
```

This downloads `Rent_Workbook_2025.xlsx` with data populated from the template.

**Full test with all 10 properties (KN01-KN10) and 12 months each:**

See `test_rent_workbook.sh` for a complete example with 120 rows.
