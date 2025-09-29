FROM python:alpine AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --prefix=/install -r requirements.txt

FROM python:alpine
WORKDIR /app
COPY --from=builder /install /usr/local
COPY . .
CMD ["python", "flask/main.py"]