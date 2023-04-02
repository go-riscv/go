Tools for cross-compiling go compuler from source for `riscv64`.

## Compiled binaries

Use [latest release](https://github.com/go-riscv/go/releases/latest):

### 1.20.2

| File name                                                                                                                      | Kind      | Size  | SHA256                                                           |
|--------------------------------------------------------------------------------------------------------------------------------|-----------|-------|------------------------------------------------------------------|
| [go1.20.2.linux-riscv64.tar.gz](https://github.com/go-riscv/go/releases/download/build-230401/go1.20.2.linux-riscv64.tar.gz)   | Archive   | 154MB | bff926ef6051a768288f3c473b59a17603254b8011197c631dc2fa9b0a46b98b |
| [go-linux-riscv64-bootstrap.tbz](https://github.com/go-riscv/go/releases/download/build-230401/go-linux-riscv64-bootstrap.tbz) | Bootstrap | 88MB  | d06f0c6e6d9a141271f41d61a8d0e813cc8f162e9a2d7bf119c40ee3e7a5c2b8 |
| [go1.20.2.src.tar.gz](https://github.com/go-riscv/go/releases/download/build-230401/go1.20.2.src.tar.gz)                       | Source    | 24MB  | 4d0e2850d197b4ddad3bdb0196300179d095bb3aefd4dfbc3b36702c3728f8ab |

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
./setup.sh && ./build.sh && ./pack.sh && ./checksums.sh
```
