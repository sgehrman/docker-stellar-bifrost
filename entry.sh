#!/usr/bin/env sh

set -e

build-config /config.json > /opt/bifrost/bifrost.cfg

sleep 33333

# /go/bin/bifrost server -c /opt/bifrost/bifrost.cfg
