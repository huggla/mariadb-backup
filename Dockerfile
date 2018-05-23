FROM huggla/postgres-alpine as pg
FROM alpine:3.7

USER root

COPY --from=pg /usr/local/bin /usr/local/bin
