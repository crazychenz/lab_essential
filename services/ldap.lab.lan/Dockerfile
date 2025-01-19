FROM alpine:3.21
RUN apk add --no-cache phpldapadmin caddy php82-fpm s6
COPY php.ini /etc/php82/
COPY init.sh /
COPY Caddyfile /etc/caddy/
COPY www.conf /etc/php82/php-fpm.d/
COPY config.php /etc/phpldapadmin/
RUN mkdir /etc/s6
COPY s6/ /etc/s6/
RUN mkdir /www
WORKDIR /www
ENTRYPOINT ["/init.sh"]
