FROM alpine:3.23

RUN apk update && apk add --no-cache \
    bash \
    curl \
    mariadb-client \
    php83 \
    php83-fpm \
    php83-mysqli \
    php83-json \
    php83-curl \
    php83-dom \
    php83-exif \
    php83-fileinfo \
    php83-mbstring \
    php83-openssl \
    php83-xml \
    php83-zip \
    php83-phar \
    php83-iconv \
    php83-tokenizer \
    php83-session \
    php83-ctype

RUN ln -s /usr/bin/php83 /usr/bin/php

RUN curl -fsSL -o /usr/local/bin/wp \
        https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp

RUN mkdir -p /var/www/html /run/php

COPY tools/wordpress-entrypoint.sh /usr/local/bin/wordpress-entrypoint.sh
RUN chmod +x /usr/local/bin/wordpress-entrypoint.sh

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["wordpress-entrypoint.sh"]
