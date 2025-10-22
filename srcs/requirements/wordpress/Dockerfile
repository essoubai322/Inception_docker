FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    php-fpm \
    php-mysql \
    curl \
    mariadb-client \
    php-curl \
    php-xml \
    php-json \
    php-mbstring \
    && rm -rf /var/lib/apt/lists/*

RUN sed -ri 's~^listen = .*~listen = 9000~g' /etc/php/*/fpm/pool.d/www.conf

RUN mkdir -p /var/www/html

RUN chown -R www-data:www-data /var/www/html

COPY ./tools/setup.sh /tmp/setup.sh

RUN chmod +x /tmp/setup.sh

CMD [ "/tmp/setup.sh" ]