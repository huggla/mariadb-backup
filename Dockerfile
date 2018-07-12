FROM huggla/mariadb as stage1
FROM huggla/alpine as stage2

COPY --from=stage1 /mariadb-apks /mariadb-apks
COPY ./rootfs /rootfs

RUN apk --no-cache --allow-untrusted add /mariadb-apks/mariadb-common-10.3.7-r0.apk /mariadb-apks/mariadb-client-10.3.7-r0.apk \
 && rm -rf /mariadb-apks \
 && mkdir -p /rootfs/usr/bin \
 && mv /usr/bin/mysqldump /rootfs/usr/bin/ \

FROM huggla/backup-alpine

COPY --from=stage2 /rootfs /

RUN apk --no-cache add libressl2.7-libcrypto libressl2.7-libssl \
 && ln /usr/bin/mysqldump /usr/local/bin/mysqldump

ENV VAR_LINUX_USER="mysql" \
    VAR_PORT="3306" \
    VAR_SOCKET="/run/mysqld/mysqld.sock"

USER starter
