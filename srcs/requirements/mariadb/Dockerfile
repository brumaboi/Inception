FROM alpine:3.23

RUN apk update && apk add --no-cache \
    mariadb \
    mariadb-client \
    bash

RUN mkdir -p /run/mysqld /var/lib/mysql && chown -R mysql:mysql /run/mysqld /var/lib/mysql && chmod 755 /run/mysqld
COPY tools/mariadb-entrypoint.sh /usr/local/bin/mariadb-entrypoint.sh

RUN chmod +x /usr/local/bin/mariadb-entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["mariadb-entrypoint.sh"]