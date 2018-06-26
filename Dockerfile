FROM huggla/mariadb as mariadb
FROM huggla/alpine:20180614-edge

USER root

COPY --from=mariadb /mariadb-apks /mariadb-apks
COPY ./start /start

RUN apk --no-cache --allow-untrusted add /mariadb-apks/mariadb-common-10.3.7-r0.apk /mariadb-apks/mariadb-client-10.3.7-r0.apk \
 && rm -rf /mariadb-apks \
 && ln /usr/bin/mysqldump /usr/local/bin/mysqldump

ENV VAR_LINUX_USER="mysql" \
    VAR_FINAL_COMMAND="/usr/sbin/crond -f -d 8" \
    VAR_BACKUP_DIR="/pgbackup" \
    VAR_PORT="5432" \
    VAR_FORMAT="directory" \
    VAR_JOBS="1" \
    VAR_COMPRESS="6" \
    VAR_DUMP_GLOBALS="yes" \
    VAR_DELETE_DUPLICATES="yes"

USER starter
