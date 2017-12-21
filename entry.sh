#!/usr/bin/env sh

set -e

/build-config /config.json > /bifrost.cfg

/go/bin/bifrost server -c /bifrost.cfg
