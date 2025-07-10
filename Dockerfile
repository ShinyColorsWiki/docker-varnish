FROM golang:alpine as exporter

ENV UPDATE_FLAG=2

RUN apk add --no-cache git && \
    git clone https://github.com/jonnenauha/prometheus_varnish_exporter.git /src

WORKDIR /src
RUN go build -o prometheus_varnish_exporter .

FROM varnish:alpine

USER root

RUN apk add --update --no-cache curl

COPY --from=exporter /src/prometheus_varnish_exporter /usr/local/bin

USER varnish

# Thanks to https://stackoverflow.com/a/64041910
ENV HEALTHCHECK_URL "http://varnish:80/w/api.php?action=query&meta=siteinfo&siprop=statistics&format=json"
HEALTHCHECK --interval=30s --timeout=30s --start-period=15s \
    CMD curl -sf -L -H 'Cache-Control: no-cache, no-store' --retry 20 --max-time 2 --retry-delay 1 --retry-max-time 20 "${HEALTHCHECK_URL}" || exit 1
