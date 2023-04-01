#!/bin/bash

set -e
set -o pipefail

if [[ $# -eq 0 ]] ; then
  echo 'No argument provided'
  exit 1
fi


VERSION=$1

pushd "./out/${VERSION}/go/bin/"
  bindir=linux_riscv64
  if [ -d "${bindir}" ]
  then
    echo "Moving binaries from ${bindir}"
    mv ${bindir}/* .
    rm -rf ${bindir}
  fi
  file go gofmt
popd

pushd ./out
  archive="go${VERSION}.linux-riscv64.tar.gz"
  rm -f "${archive}"
  echo "Creating ${archive}"
  tar -C "${VERSION}" -czf "${archive}" go
  sha256sum "${archive}" > "${archive}.sha256.txt"
  cat "${archive}.sha256.txt"
  ls --human-readable --kibibytes -Sl "${archive}"
popd