FROM python:3.8-slim

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

COPY requirement.txt .
RUN python -m pip install --upgrade pip setuptools wheel \
    && python -m pip install -r requirement.txt

COPY app.py house.py model.pkl ./
COPY templates ./templates
COPY static ./static
COPY test_app_50_cases.py ./

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:5000/', timeout=3)"

CMD ["python", "app.py"]