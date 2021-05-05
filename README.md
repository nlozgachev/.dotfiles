# .dotfiles

Repository contains files and instructions for configuring:

- Node.js & NVM
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

#### Node Version Manager

[Repository](https://github.com/nvm-sh/nvm)

Install NVM (check for the latest version of the script first):

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
```

Install/Update Node LTS and reinstall packages:

```bash
nvm install --lts --reinstall-packages-from=current
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

#### Fish plugins

- [Fisher](https://github.com/jorgebucaran/fisher)
- [Bass](https://github.com/edc/bass)
- [fish-nvm](https://github.com/FabioAntunes/fish-nvm)

#### SpaceVim

[Repository](https://github.com/SpaceVim/SpaceVim)

```bash
curl -sLf https://spacevim.org/install.sh | bash
```

#### Fonts

- [Iosevka](https://github.com/be5invis/Iosevka)
- [Cascadia Code](https://github.com/microsoft/cascadia-code)
