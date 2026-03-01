# List available recipes
default:
    @just --list

# ── Config symlinks ───────────────────────────────────────────────────────────

# Symlink all configs to ~ using stow
link:
    cd configs && stow -vt ~ *

# Remove all config symlinks
unlink:
    cd configs && stow -Dt ~ *

# ── Bootstrap ─────────────────────────────────────────────────────────────────

# Install Homebrew (run once on a fresh machine before anything else)
brew:
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install packages, fonts, and symlink configs
setup: packages fonts link

# ── Homebrew packages ─────────────────────────────────────────────────────────

# Install required packages
packages:
    brew install just git git-delta fish stow asdf helix uv

# Install fonts
fonts:
    brew install --cask font-iosevka-nerd-font font-iosevka-term-nerd-font

# ── Languages ─────────────────────────────────────────────────────────────────

# Install Node.js LTS + pnpm via corepack (asdf)
node:
    #!/bin/sh
    asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git || true
    asdf cmd nodejs update-nodebuild
    NODE_LTS=$(asdf cmd nodejs resolve lts)
    asdf install nodejs "$NODE_LTS"
    asdf global nodejs "$NODE_LTS"
    corepack enable
    corepack prepare pnpm@latest --activate
    asdf reshim nodejs

# Install Deno (asdf)
deno:
    -asdf plugin add deno https://github.com/asdf-community/asdf-deno.git
    asdf install deno latest
    asdf global deno latest

# Install Go (asdf)
go:
    -asdf plugin add golang https://github.com/asdf-community/asdf-golang.git
    asdf install golang latest
    asdf global golang latest

# Install latest Python (uv)
python:
    uv python install

# Install Rust (rustup)
rust:
    brew install rustup
    rustup-init -y

# Install all languages
langs: node deno go python rust

# ── Updates ───────────────────────────────────────────────────────────────────

# Update all asdf plugins
update-plugins:
    asdf plugin update --all

# Update Node.js to latest LTS + pnpm
update-node:
    #!/bin/sh
    asdf plugin update nodejs
    asdf cmd nodejs update-nodebuild
    NODE_LTS=$(asdf cmd nodejs resolve lts)
    asdf install nodejs "$NODE_LTS"
    asdf global nodejs "$NODE_LTS"
    corepack prepare pnpm@latest --activate
    asdf reshim nodejs

# Update Deno to latest
update-deno:
    asdf plugin update deno
    asdf install deno latest
    asdf global deno latest

# Update Go to latest
update-go:
    asdf plugin update golang
    asdf install golang latest
    asdf global golang latest

# Update uv itself and install latest Python
update-python:
    uv self update
    uv python install

# Update Rust toolchain
update-rust:
    rustup update

# Update Homebrew packages and remove outdated versions
update-brew:
    brew update
    brew upgrade
    brew cleanup

# Update everything
update: update-plugins update-node update-deno update-go update-python update-rust update-brew

# ── GPG ───────────────────────────────────────────────────────────────────────

# Install GPG and pinentry-mac (macOS passphrase dialog)
gpg-install:
    brew install gnupg pinentry-mac

# Configure gpg-agent to use pinentry-mac
gpg-agent:
    #!/bin/sh
    mkdir -p ~/.gnupg
    chmod 700 ~/.gnupg
    echo "pinentry-program $(brew --prefix)/bin/pinentry-mac" > ~/.gnupg/gpg-agent.conf
    chmod 600 ~/.gnupg/gpg-agent.conf
    gpgconf --kill gpg-agent

# Generate a new GPG key (interactive)
gpg-generate:
    gpg --full-generate-key

# List secret keys with full fingerprints — copy the ID into ~/.gitconfig-local
gpg-list:
    gpg --list-secret-keys --keyid-format=long

# Export public key for git service provider (usage: just gpg-export your@email.com)
gpg-export email:
    gpg --armor --export {{ email }}

# Full GPG setup: install, configure agent, generate key, list keys
gpg-setup: gpg-install gpg-agent gpg-generate gpg-list
