FROM huggla/mariadb:10.3.9 as stage1
FROM huggla/alpine-slim:20180907-edge as stage2

ARG APKS="libressl2.7-libcrypto libressl2.7-libssl mariadb-client"

COPY --from=stage1 /mariadb-apks /mariadb-apks
COPY ./rootfs /rootfs

RUN echo /mariadb-apks >> /etc/apk/repositories \
 && apk --no-cache --allow-untrusted add $APKS \
 && tar -cvp -f /apk_files.tar $(apk --no-cache --quiet manifest libressl2.7-libcrypto libressl2.7-libssl | awk -F "  " '{print $2;}') \
 && tar -xvp -f /apk_files.tar -C /rootfs/ \
 && rm -rf /mariadb-apks/* \
 && mkdir -p /rootfs/usr/bin /rootfs/usr/local/bin \
 && mv /usr/bin/mysqldump /rootfs/usr/local/bin/mysqldump \
 && cd /rootfs/usr/bin \
 && ln -fs ../local/bin/mysqldump mysqldump

FROM huggla/backup-alpine

COPY --from=stage2 /rootfs /

ENV VAR_LINUX_USER="mysql" \
    VAR_PORT="3306" \
    VAR_SOCKET="/run/mysqld/mysqld.sock"

USER starter

ONBUILD USER root
