#!/bin/bash

export GOARCH=riscv64
export GOOS=linux

set -e
set -o pipefail

OUTPUT="_out/"

VERSION=1.20.3
HASH=e447b498cde50215c4f7619e5124b0fc4e25fb5d16ea47271c47f278e7aa763a
FILE="go${VERSION}.src.tar.gz"

mkdir -p "${OUTPUT}"
cd "${OUTPUT}"

if [ -d "go-linux-riscv64-bootstrap" ]
then
  echo "Already set up."
  exit 0
fi

BOOTSTRAP_FILE="go-linux-riscv64-bootstrap.tbz"

if [ -f "${BOOTSTRAP_FILE}" ]
then
  echo "Using ${BOOTSTRAP_FILE}"
  tar -xjf "${BOOTSTRAP_FILE}"
  echo "Bootstrap restored from ${BOOTSTRAP_FILE}"
  exit 0
fi


echo "Downloading ${FILE} to boostrap"
curl --proto '=https' --tlsv1.2 -sSf "https://dl.google.com/go/${FILE}" -o "${FILE}"
echo "${HASH} ${FILE}" | sha256sum --check
rm -rf "./go"
tar -xzf "${FILE}"

echo "Building bootstrap"
pushd "go/src"
  ./bootstrap.bash
popd
