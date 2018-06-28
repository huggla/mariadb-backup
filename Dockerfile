FROM huggla/mariadb as mariadb
FROM huggla/alpine:20180627-edge as tmp

USER root

COPY --from=mariadb /mariadb-apks /mariadb-apks
COPY ./start /start
COPY ./bin /usr/local/bin

RUN apk --no-cache --allow-untrusted add /mariadb-apks/mariadb-common-10.3.7-r0.apk /mariadb-apks/mariadb-client-10.3.7-r0.apk \
 && rm -rf /mariadb-apks

FROM huggla/alpine:20180627-edge

USER root

COPY --from=tmp /usr/bin /usr/bin

RUN ln /usr/bin/mysqldump /usr/local/bin/mysqldump

ENV VAR_LINUX_USER="mysql" \
    VAR_FINAL_COMMAND="/usr/sbin/crond -f -d 8" \
    VAR_BACKUP_DIR="/mysqlbackup" \
    VAR_PORT="3306" \
    VAR_DELETE_DUPLICATES="yes"

USER starter
