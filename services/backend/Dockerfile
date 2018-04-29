FROM python:3-alpine

RUN pip install requests

WORKDIR /server
COPY . .

ENV SERVER_PORT 3000
EXPOSE $SERVER_PORT

ENTRYPOINT ./server.py $SERVER_PORT
