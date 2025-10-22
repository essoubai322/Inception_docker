FROM debian:bookworm-slim

RUN apt-get update && apt-get install nginx openssl -y \
    && rm -rf /var/lib/apt/lists/*

RUN openssl req -newkey rsa:2048 -nodes \
    -keyout /etc/ssl/private/nginx.key -x509 \
    -days 365 -out /etc/ssl/certs/nginx.crt \
    -subj "/C=MA/ST=BE/O=1337/CN=asebaai.42.fr"

COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./tools/setup.sh /tmp/setup.sh

RUN chmod +x /tmp/setup.sh

CMD [ "/tmp/setup.sh" ]