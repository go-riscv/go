#!/bin/bash

export GOARCH=riscv64
export GOOS=linux

set -e
set -o pipefail

if [[ $# -eq 0 ]] ; then
    echo 'No argument provided'
    exit 1
fi

VERSION=$1

echo "Building version ${VERSION}"


OUTPUT="./out/${VERSION}/"

set -x
mkdir -p "${OUTPUT}"
pushd "${OUTPUT}"

curl --proto '=https' --tlsv1.2 -sSf "https://dl.google.com/go/go${VERSION}.src.tar.gz" | tar -xz

pushd go/src
./make.bash
