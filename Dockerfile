FROM huggla/mariadb as stage1
FROM huggla/alpine as stage2

USER root

COPY --from=stage1 /mariadb-apks /mariadb-apks
COPY ./rootfs /rootfs

RUN apk --no-cache --allow-untrusted add /mariadb-apks/mariadb-common-10.3.7-r0.apk /mariadb-apks/mariadb-client-10.3.7-r0.apk \
 && rm -rf /mariadb-apks \
 && apk --no-cache add libressl2.7-libcrypto libressl2.7-libssl \
 && tar -cvp -f /installed_files.tar $(apk manifest libressl2.7-libcrypto libressl2.7-libssl | awk -F "  " '{print $2;}') \
 && tar -xvp -f /installed_files.tar -C /rootfs/ \
 && mkdir -p /rootfs/usr/bin \
 && mv /usr/bin/mysqldump /usr/local/bin/ \
 && ln -s /usr/local/bin/mysqldump /usr/bin/ \
 && mv /usr/bin/mysqldump /rootfs/usr/bin/ \
 && mv /usr/local/bin/mysqldump /rootfs/usr/local/bin/

FROM huggla/backup-alpine

COPY --from=stage2 /rootfs /

ENV VAR_LINUX_USER="mysql" \
    VAR_PORT="3306" \
    VAR_SOCKET="/run/mysqld/mysqld.sock"
