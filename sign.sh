#!/bin/bash

set -e
set -o pipefail

ver="${GOVERSION:-1.20.3}"
archive="go${ver}.linux-riscv64.tar.gz"
bootstrap=go-linux-riscv64-bootstrap.tbz
src=go${ver}.src.tar.gz
sums=checksums.sha256.txt
key=943040B9817AC4C7

cd _out
for file in "${archive}" "${bootstrap}" "${src}" "${sums}"; do
  gpg --batch --yes --default-key "${key}" --output "${file}.asc" --armor --detach-sig "${file}"
  gpg --batch --default-key "${key}" --verify "${file}.asc" "${file}"
done
