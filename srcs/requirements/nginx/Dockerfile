FROM alpine:3.23

RUN apk update && apk add --no-cache \
    nginx \
    openssl \
    bash

RUN mkdir -p /etc/nginx/ssl /var/www/html /run/nginx

COPY tools/nginx-entrypoint.sh /usr/local/bin/nginx-entrypoint.sh
RUN chmod +x /usr/local/bin/nginx-entrypoint.sh

EXPOSE 443

ENTRYPOINT ["nginx-entrypoint.sh"]