FROM python:3.9-slim-bookworm

ENV PYTHONUNBUFFERED=1
EXPOSE 8000
WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends netcat-traditional gcc python3-dev libpq-dev && \
    rm -rf /var/lib/apt/lists/*

COPY pyproject.toml ./

RUN pip install poetry && \
    poetry config virtualenvs.create false && \
    poetry install --no-root

COPY . ./

RUN pip install "setuptools<70.0.0"

CMD alembic upgrade head && \
    uvicorn --host=0.0.0.0 app.main:app
