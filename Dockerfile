FROM golang:alpine as exporter

RUN apk add --no-cache git && \
    go get github.com/jonnenauha/prometheus_varnish_exporter

WORKDIR /go/src/github.com/jonnenauha/prometheus_varnish_exporter
RUN go build

FROM varnish:alpine

COPY --from=exporter /go/bin/prometheus_varnish_exporter /usr/local/bin

USER varnish
