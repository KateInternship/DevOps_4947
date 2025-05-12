FROM python:3.11-slim AS build

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        patchelf \
        python3-venv && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip nuitka && \
    pip install --no-cache-dir -r requirements.txt

COPY . .

RUN nuitka app.py \
    --onefile \
    --follow-imports \
    --include-data-dir=templates=templates \
    --include-data-dir=static=static \
    --include-data-dir=csv_logs=csv_logs \
    --output-dir=dist

FROM gcr.io/distroless/python3-debian12

COPY --from=build /app/dist/app.bin /app/app.bin

COPY --from=build /app/templates /templates
COPY --from=build /app/static    /static
COPY --from=build /app/csv_logs      /csv_logs

EXPOSE 8000
ENTRYPOINT ["/app/app.bin"]
