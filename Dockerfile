FROM huggla/mariadb:10.3.9 as stage1
FROM huggla/alpine:20180713-edge as stage2

USER root

COPY --from=stage1 /mariadb-apks /mariadb-apks
COPY ./rootfs /rootfs

RUN apk --no-cache --allow-untrusted add /mariadb-apks/mariadb-common.apk /mariadb-apks/mariadb-client.apk \
 && rm -rf /mariadb-apks \
 && apk --no-cache add libressl2.7-libcrypto libressl2.7-libssl \
 && tar -cvp -f /installed_files.tar $(apk manifest libressl2.7-libcrypto libressl2.7-libssl | awk -F "  " '{print $2;}') \
 && tar -xvp -f /installed_files.tar -C /rootfs/ \
 && mkdir -p /rootfs/usr/bin /rootfs/usr/local/bin \
 && mv /usr/bin/mysqldump /rootfs/usr/local/bin/mysqldump \
 && cd /rootfs/usr/bin \
 && ln -s ../local/bin/mysqldump mysqldump

FROM huggla/backup-alpine:20180713-edge

COPY --from=stage2 /rootfs /

ENV VAR_LINUX_USER="mysql" \
    VAR_PORT="3306" \
    VAR_SOCKET="/run/mysqld/mysqld.sock"
