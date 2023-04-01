#!/bin/bash

export GOARCH=riscv64
export GOOS=linux
GOROOT_BOOTSTRAP="$(realpath _out/go-linux-riscv64-bootstrap)"

set -e
set -o pipefail

ver="${GOVERSION:-1.20.2}"

if [ ! -d "${GOROOT_BOOTSTRAP}" ]
then
  echo "No bootstrap found at ${GOROOT_BOOTSTRAP}. Run ./setup.sh first."
  exit 1
else
  echo "Bootstrap: ${GOROOT_BOOTSTRAP}"
fi

echo "Building version ${ver}"

out="_out/${ver}"
out_file="_out/go${ver}.linux-riscv64.tar.gz"

if [ -f "${out_file}" ]
then
  echo "Already built as ${out_file}"
  exit 0
fi

set -x
mkdir -p "${out}"
src="go${ver}.src.tar.gz"

cd _out
curl --proto '=https' --tlsv1.2 -sSf "https://dl.google.com/go/${src}" -o "${src}"
echo "${GOSHA256} ${src}" | sha256sum --check
tar -C "${ver}" -xzf "${src}"

cd "${ver}/go/src"
./make.bash
