FROM python:alpine AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

FROM python:alpine
WORKDIR /app
COPY --from=builder /install /usr/local
COPY . .
RUN addgroup -S user && adduser -S -G user user
RUN apk add --no-cache curl=8.14.1-r2
HEALTHCHECK --interval=30s \
            --timeout=5s \
            --retries=3 \
            CMD curl --fail http://localhost:5000/health || exit 1
USER user            
CMD ["python", "flask/main.py"]