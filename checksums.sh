#!/bin/bash

set -e
set -o pipefail

ver="${GOVERSION:-1.20.3}"
archive="go${ver}.linux-riscv64.tar.gz"
bootstrap=go-linux-riscv64-bootstrap.tbz
src=go${ver}.src.tar.gz

cd _out

sha256sum "${archive}" "${bootstrap}" "${src}" > checksums.sha256.txt