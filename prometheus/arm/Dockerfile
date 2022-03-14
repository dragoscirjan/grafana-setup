ARG ARCH="arm"
ARG OS="linux"
FROM quay.io/prometheus/busybox-${OS}-${ARCH}:latest
LABEL maintainer="Dragos Cirjan <dragos.cirjan@gmail.com>"

ARG ARCH="arm"
ARG OS="linux"
COPY .build/${OS}-${ARCH}/node_exporter /bin/node_exporter

EXPOSE      9100
USER        nobody
ENTRYPOINT  [ "/bin/node_exporter" ]