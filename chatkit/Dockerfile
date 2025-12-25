# Stage 1: build the Vite frontend
FROM node:20.18.0-slim AS frontend-build
WORKDIR /app/frontend
COPY frontend/package.json frontend/package-lock.json* ./
RUN npm install
COPY frontend ./
RUN npm run build

# Stage 2: package the FastAPI backend with the built assets
FROM python:3.12.0-slim
WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Make sure pip tooling is current
RUN pip install --no-cache-dir --upgrade pip setuptools wheel

# Copy backend code and template data before installing dependencies
COPY backend/pyproject.toml backend/pyproject.toml
COPY backend ./backend
COPY templates ./templates

# Install the backend package and its dependencies
RUN pip install --no-cache-dir /app/backend

# Copy built frontend assets to the installed package location
RUN python -c "import app; import shutil; from pathlib import Path; static_dir = Path(app.__file__).parent / 'static'; static_dir.mkdir(exist_ok=True)"
COPY --from=frontend-build /app/frontend/dist /usr/local/lib/python3.12/site-packages/app/static

EXPOSE 8080

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]