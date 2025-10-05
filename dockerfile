FROM python:alpine AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --prefix=/install -r requirements.txt

FROM python:alpine
WORKDIR /app
COPY --from=builder /install /usr/local
COPY . .
HEALTHCHECK --interval=30s \
            --timeout=5s \
            --retries=3 \
            CMD curl --fail http://localhost:5000/health || exit 1
CMD ["python", "flask/main.py"]