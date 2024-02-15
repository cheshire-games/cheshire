FROM python:3.11-slim

WORKDIR /app
RUN pip install --upgrade pip

COPY requirements.txt .
RUN python -m pip install -r requirements.txt
COPY src/ ./src

ENTRYPOINT ["python", "-m", "src.main"]
