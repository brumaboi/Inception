FROM alpine:3.22

RUN apk update && apk add mariadb mariadb-client bash

RUN mkdir -p /run/mysqld /var/lib/mysql && chown -R mysql:mysql /run/mysqld /var/lib/mysql && chmod 755 /run/mysqld
COPY tools/mariadb-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/mariadb-entrypoint.sh

VOLUME ["/var/lib/mysql"]
EXPOSE 3306

ENTRYPOINT [ "mariadb-entrypoint.sh" ]