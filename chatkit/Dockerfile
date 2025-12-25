from pathlib import Path
from openpyxl import load_workbook

TEMPLATE_FILENAME = "Property_Rents_Received_Template.xlsx"


def resolve_template_path() -> Path:
    """Resolve the workbook template path in local dev and in Fly container."""
    candidates = [
        # legacy location (some deployments)
        Path("/app/templates") / TEMPLATE_FILENAME,
        # Fly/container location when backend is copied to /app/backend
        Path("/app/backend/templates") / TEMPLATE_FILENAME,
        # repo/dev location (backend/templates)
        Path(__file__).resolve().parents[1] / "templates" / TEMPLATE_FILENAME,
    ]
    for path in candidates:
        if path.is_file():
            return path
    raise FileNotFoundError(f"Template not found. Tried: {', '.join(str(p) for p in candidates)}")


def load_rent_workbook():
    template_path = resolve_template_path()
    return load_workbook(template_path)

# rest of the code that uses load_rent_workbook() instead of directly loading the template path