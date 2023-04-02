all: bootstrap build pack checksums

build:
	bash build.sh
pack:
	bash pack.sh
clean:
	rf -rf _out
checksums:
	bash checksums.sh
bootstrap:
	bash bootstrap.sh
notes:
	go run ./cmd/release > _out/release.md

.DEFAULT_GOAL := all
.PHONY: build pack clean checksums notes bootstrap