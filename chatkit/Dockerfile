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

# Copy built frontend assets into the backend static directory
COPY --from=frontend-build /app/frontend/dist /app/backend/app/static

# Install the backend package and its dependencies
RUN pip install --no-cache-dir /app/backend

EXPOSE 8080

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]