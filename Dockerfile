FROM golang:alpine as exporter

RUN apk add --no-cache git && \
    git clone https://github.com/jonnenauha/prometheus_varnish_exporter.git /src
    

WORKDIR /src
RUN go build -o prometheus_varnish_exporter .

FROM varnish:alpine

COPY --from=exporter /src/prometheus_varnish_exporter /usr/local/bin

USER varnish
