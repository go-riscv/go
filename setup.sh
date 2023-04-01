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
  shasum --check ${BOOTSTRAP_FILE}.sha256.txt
  echo "Checked, extracting."
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

sha256sum "${BOOTSTRAP_FILE}" > "${BOOTSTRAP_FILE}.sha256.txt"
cat "${BOOTSTRAP_FILE}.sha256.txt"
ls --human-readable --kibibytes -Sl "${BOOTSTRAP_FILE}"