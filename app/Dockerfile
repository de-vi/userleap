FROM node:current-alpine
COPY frontend /frontend
RUN cd /frontend && npm install && npm run build

FROM python:3-alpine
COPY --from=0 /frontend/build ./ui
RUN pip install Flask
COPY hello.py hello.py

ENTRYPOINT FLASK_APP=hello.py flask run --host=0.0.0.0
