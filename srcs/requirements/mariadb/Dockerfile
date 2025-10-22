FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install mariadb-server mariadb-client -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/lib/mysql/*

COPY conf/my.cnf /etc/mysql/my.cnf
COPY tools/setup.sh /tmp/setup.sh

RUN chmod +x /tmp/setup.sh

CMD [ "/tmp/setup.sh" ]