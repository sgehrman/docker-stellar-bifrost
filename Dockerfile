FROM golang:alpine as builder

ADD dependencies /dependencies
RUN chmod +x /dependencies
RUN /dependencies

# deploy bifrost binary
RUN mkdir -p /go/src/github.com/stellar/ \
    && git clone https://github.com/stellar/go.git /go/src/github.com/stellar/go \
    && cd /go/src/github.com/stellar/go \
    && curl https://glide.sh/get | sh \
    && glide install \
    && go install github.com/stellar/go/services/bifrost

# build config file here since it needs envsubst installed by gettext
ADD build-config.sh /build-config.sh
RUN chmod +x /build-config.sh

ADD config.json /config.json
RUN build-config < /config.json > /bifrost.cfg

FROM alpine:latest

COPY --from=builder /go/bin/bifrost /go/bin/bifrost
COPY --from=builder /bifrost.cfg /bifrost.cfg

# show config file
RUN cat /bifrost.cfg

RUN ["mkdir", "-p", "/opt/bifrost"]

ADD entry.sh /entry.sh
RUN chmod +x /entry.sh

ENTRYPOINT ["/entry.sh"]

EXPOSE 8000
