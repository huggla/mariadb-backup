ARG TAG="20181204"
ARG BASEIMAGE="huggla/backup-alpine:$TAG"
ARG RUNDEPS="libssl1.1"
ARG BUILDDEPS="mariadb-client"
ARG BUILDCMDS=\
"   mkdir -p /imagefs/usr/bin /imagefs/usr/lib "\
"&& cp -a /usr/bin/mysqldump /imagefs/usr/bin/ "
ARG EXECUTABLES="/usr/bin/mysqldump"

#---------------Don't edit----------------
FROM ${CONTENTIMAGE1:-scratch} as content1
FROM ${CONTENTIMAGE2:-scratch} as content2
FROM ${INITIMAGE:-${BASEIMAGE:-huggla/base:$TAG}} as init
FROM ${BUILDIMAGE:-huggla/build:$TAG} as build
FROM ${BASEIMAGE:-huggla/base:$TAG} as image
COPY --from=build /imagefs /
#-----------------------------------------

ENV VAR_LINUX_USER="mysql" \
    VAR_PORT="3306" \
    VAR_SOCKET="/run/mysqld/mysqld.sock" \
    VAR_KEEP_CAPS="cap_setgid"

#---------------Don't edit----------------
USER starter
ONBUILD USER root
#-----------------------------------------
