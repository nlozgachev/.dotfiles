# .dotfiles

Repository contains files and instructions for configuring and installing:

- Node.js
- Deno
- Go
- Fish shell
- SpaceVim
- Git
- Fonts

## Before Install

Ensure that you have required packages in the system.

Using APT:

```bash
sudo apt install fish git stow
```

Using DNF:

```bash
sudo dnf install fish git stow
```

## Usage

To configure everything:

```bash
stow -vt ~ *
```

## Tools

#### Node.js

Install using [n-install](https://github.com/tj/n) tool:

```bash
curl -L https://git.io/n-install | bash
```

#### Deno

[Repository](https://github.com/denoland/deno)

```bash
curl -fsSL https://deno.land/x/install/install.sh | sh
```

#### Go

Install using [getgo](https://github.com/golang/tools/tree/master/cmd/getgo) tool:

```bash
curl -LO https://get.golang.org/$(uname)/go_installer && chmod +x go_installer && ./go_installer && rm go_installer
```

#### SpaceVim

[Repository](https://github.com/SpaceVim/SpaceVim)

```bash
curl -sLf https://spacevim.org/install.sh | bash
```

#### Fonts

- [Iosevka](https://github.com/be5invis/Iosevka)
- [Cascadia Code](https://github.com/microsoft/cascadia-code)
