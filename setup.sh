#!/bin/bash

export GOARCH=riscv64
export GOOS=linux

set -e
set -o pipefail

OUTPUT="./out/"

VERSION=1.20.2
HASH=4d0e2850d197b4ddad3bdb0196300179d095bb3aefd4dfbc3b36702c3728f8ab
FILE="go${VERSION}.src.tar.gz"

mkdir -p "${OUTPUT}"
pushd "${OUTPUT}"

if [ -d "go-linux-riscv64-bootstrap" ]
then
  echo "Already setup"
  exit 0
fi

set -x

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

pushd "go/src"
./bootstrap.bash
