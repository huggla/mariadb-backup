FROM huggla/mariadb as mariadb
FROM huggla/alpine:20180628-edge as tmp

USER root

COPY --from=mariadb /mariadb-apks /mariadb-apks

RUN apk --no-cache --allow-untrusted add /mariadb-apks/mariadb-common-10.3.7-r0.apk /mariadb-apks/mariadb-client-10.3.7-r0.apk \
 && rm -rf /mariadb-apks

FROM huggla/backup-alpine:20180628-edge

USER root

COPY --from=tmp /usr/bin /usr/bin
COPY ./start /start
COPY ./bin /usr/local/bin

RUN apk --no-cache add libressl2.7-libcrypto libressl2.7-libssl \
 && ln /usr/bin/mysqldump /usr/local/bin/mysqldump

ENV VAR_LINUX_USER="mysql" \
    VAR_PORT="3306" \
    VAR_SOCKET="/run/mysqld/mysqld.sock"

USER starter
