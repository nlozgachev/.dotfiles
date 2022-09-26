# .dotfiles

Repository contains files and instructions for configuring and installing:

## Toolchain

- Node.js
- Deno
- Rust
- Go
- Fish shell
- Git
- Fonts

## Usage

To setup configs:

```bash
stow -vt ~ *
```

To install specific tools using makefile:

```bash
make <CMD_NAME>

# to install everything necessary for development in MacOS
make setup_macos
```
