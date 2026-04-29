FROM alpine:3.22 

RUN apk update --no-cache
RUN apk add bash 
RUN apk add curl
RUN apk add mariadb-client
RUN apk add icu-data-full
RUN apk add ghostscript
RUN apk	add imagemagick openssl php83 php83-fpm php83-phar php83-json php83-mysqli
RUN apk add php83-curl php83-dom php83-exif php83-fileinfo php83-pecl-igbinary
RUN apk add php83-pecl-imagick php83-intl php83-mbstring php83-openssl
RUN apk add php83-xml php83-zip php83-iconv php83-shmop php83-simplexml php83-sodium
RUN apk add php83-xmlreader php83-zlib php83-tokenizer
RUN addgroup -g 101 -S nginx && adduser -u 100 -D -S -G nginx nginx

RUN cd /usr/local/bin && curl -o wp -L https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp
COPY tools/wordpress-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/wordpress-entrypoint.sh

ENTRYPOINT [ "wordpress-entrypoint.sh" ]