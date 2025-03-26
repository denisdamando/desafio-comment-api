FROM python:3.7.4-slim

WORKDIR /app

ADD requirements.txt .

RUN pip install --upgrade pip && pip install -r requirements.txt

COPY app/ .

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--log-level", "debug", "api:app"]