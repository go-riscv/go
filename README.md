Tools for cross-compiling go compiler from source for `riscv64`.

Reference:
- [go#59113](https://github.com/golang/go/issues/59113) (declined): x/website: add linux/riscv64 downloads
- [go#53383](https://github.com/golang/go/issues/53383): clarify Go support policy for secondary ports
- [go#53862][53862]: x/build: build cross-compiled releases for secondary ports

> Our hope is to be able to publish binaries for all supported ports. See [#53862][53862].

Currently, binaries for go compiler are not available for `linux/riscv64`, so `go-riscv` is
providing them with a way to [build it locally](#building-locally).

[53862]: https://github.com/golang/go/issues/53862

## Download

Use [latest release](https://github.com/go-riscv/go/releases/latest):

### 1.20.3

| File name | Kind | Size | SHA256 |
|-----------|------|------|--------|
| [**go1.20.3.linux-riscv64.tar.gz**](https://github.com/go-riscv/go/releases/download/build-230412.0/go1.20.3.linux-riscv64.tar.gz) | **Archive** | **154MB** | **cc04195c17885aab1264df24d09e417854bebbc6e567e422cdce1eb6399053bc** |
| [go-linux-riscv64-bootstrap.tbz](https://github.com/go-riscv/go/releases/download/build-230412.0/go-linux-riscv64-bootstrap.tbz) | Bootstrap | 88MB | 9172512332c26f8adccce9a0177292f19efa2f0b5eca5ac4855539973a301195 |
| [go1.20.3.src.tar.gz](https://github.com/go-riscv/go/releases/download/build-230412.0/go1.20.3.src.tar.gz) | Source | 24MB | e447b498cde50215c4f7619e5124b0fc4e25fb5d16ea47271c47f278e7aa763a |

#### Download

```bash
wget "https://github.com/go-riscv/go/releases/download/build-230401/go1.20.2.linux-riscv64.tar.gz"
```

#### Verify

```bash
echo "bff926ef6051a768288f3c473b59a17603254b8011197c631dc2fa9b0a46b98b go1.20.2.linux-riscv64.tar.gz" | sha256sum --check
```

#### Install

```bash
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.20.2.linux-riscv64.tar.gz
```

#### Add to PATH

You can create `/etc/profile.d/go.sh`.

```bash
sudo nano /etc/profile.d/go.sh
```

Write following contents:

```bash
#!/bin/bash
# sets envs for golang
if [ -z "$GOPATH" ]; then
  export GOROOT="/usr/local/go"
  export GOPATH="/go"
  export PATH="$GOPATH/bin:$GOROOT/bin:$PATH"
fi
```

Save and make it executable:

```bash
sudo chmod +x /etc/profile.d/go.sh
```

You can check it without creating new shell session:

```
source /etc/profile.d/go.sh
go version
```

## Building locally

```
git clone https://github.com/go-riscv/go.git && cd go
```

Set release version and `Source` file `sha256` from https://go.dev/dl/.
```
export GOVERSION=1.20.2
export GOSHA256=4d0e2850d197b4ddad3bdb0196300179d095bb3aefd4dfbc3b36702c3728f8ab
```

```
make
```

Your release will be available as `_out/go1.20.2.linux-riscv64.tar.gz`:

```console
$ file _out/go1.20.2.linux-riscv64.tar.gz
_out/go1.20.2.linux-riscv64.tar.gz: gzip compressed data, from Unix, original size modulo 2^32 373309440
```
