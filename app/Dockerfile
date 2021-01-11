FROM python:3-alpine

RUN pip install Flask
COPY hello.py hello.py

ENTRYPOINT FLASK_APP=hello.py flask run --host=0.0.0.0
