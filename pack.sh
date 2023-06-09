#!/bin/bash

set -e
set -o pipefail

ver="${GOVERSION:-1.20.2}"
archive="go${ver}.linux-riscv64.tar.gz"

pushd _out
  archive="go${ver}.linux-riscv64.tar.gz"
  if [ -f "${archive}" ]
  then
    echo "Already built as ${archive}"
    exit 0
  fi

  pushd "${ver}/go/bin/"
    bindir=linux_riscv64
    if [ -d "${bindir}" ]
    then
      echo "Moving binaries from ${bindir}"
      mv ${bindir}/* .
      rm -rf ${bindir}
    fi
    file go gofmt
  popd

  echo "Creating ${archive}"
  tar -C "${ver}" -czf "${archive}" go
popd
