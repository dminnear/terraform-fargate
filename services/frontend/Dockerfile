FROM nginx:alpine

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 8080

ARG BACKEND_ENDPOINT

RUN sed -i "s~BACKEND_ENDPOINT~$BACKEND_ENDPOINT~g" /etc/nginx/nginx.conf
