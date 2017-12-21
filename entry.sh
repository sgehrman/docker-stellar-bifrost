#!/usr/bin/env sh

set -e

build-config /config.json > /opt/bifrost/bifrost.cfg

/go/bin/bifrost server -c /opt/bifrost/bifrost.cfg
