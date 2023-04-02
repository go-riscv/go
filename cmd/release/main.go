package main

import (
	"bufio"
	"bytes"
	_ "embed"
	"fmt"
	"os"
	"strings"
	"text/template"

	"github.com/go-faster/errors"
)

type Context struct {
	Version string
	Files   []File

	Archive File
}

func (f File) F(v string) string {
	if f.Kind != "Archive" {
		return v
	}
	return "**" + v + "**" // bold
}

type File struct {
	Name   string // go-linux-riscv64-bootstrap.tbz
	URL    string // https://github.com/go-riscv/go/releases/download/build-2204/go-linux-riscv64-bootstrap.tbz
	Kind   string // Source, Archive, Bootstrap
	Size   string // 39MB
	SHA256 string
}

var (
	//go:embed RELEASE.md.tmpl
	body string

	t = template.Must(template.New("template").Parse(body))
)

func run() error {
	if err := os.Chdir("_out"); err != nil {
		return errors.Wrap(err, "chdir")
	}
	ctx := Context{
		Version: os.Getenv("GOVERSION"),
	}
	if ctx.Version == "" {
		return errors.New("no version")
	}

	checksums, err := os.ReadFile("checksums.sha256.txt")
	if err != nil {
		return errors.Wrap(err, "read checksums")
	}
	ref := os.Getenv("GITHUB_REF_NAME")
	if ref == "" {
		return errors.New("no GITHUB_REF_NAME")
	}
	scanner := bufio.NewScanner(bytes.NewReader(checksums))
	for scanner.Scan() {
		line := scanner.Text()
		if line == "" {
			continue
		}
		f := File{
			Kind: "Archive",
		}
		if _, err := fmt.Sscanf(line, "%s %s", &f.SHA256, &f.Name); err != nil {
			return errors.Wrap(err, "scan")
		}

		if f.Name == "go-linux-riscv64-bootstrap.tbz" {
			f.Kind = "Bootstrap"
		}
		if strings.Contains(f.Name, "src") {
			f.Kind = "Source"
		}

		stat, err := os.Stat(f.Name)
		if err != nil {
			return errors.Wrap(err, "stat")
		}
		f.Size = fmt.Sprintf("%dMB", stat.Size()/1024/1024)
		f.URL = fmt.Sprintf("https://github.com/go-riscv/go/releases/download/%s/%s", ref, f.Name)
		ctx.Files = append(ctx.Files, f)

		if f.Kind == "Archive" {
			ctx.Archive = f
		}
	}

	if err := t.Execute(os.Stdout, ctx); err != nil {
		return errors.Wrap(err, "exec")
	}

	return nil
}

func main() {
	if err := run(); err != nil {
		_, _ = fmt.Fprintf(os.Stderr, "error: %+v", err)
		os.Exit(1)
	}
}
