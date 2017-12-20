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

FROM alpine:latest

COPY --from=builder /go/bin/bifrost /go/bin/bifrost

# for envsubst
RUN apk add gettext

# create config file
ADD config.txt /config.txt
RUN envsubst < /config.txt > /bifrost.cfg
RUN cat /bifrost.cfg

ADD entry.sh /entry.sh
RUN chmod +x /entry.sh

ENTRYPOINT ["/entry.sh"]

EXPOSE 8000
