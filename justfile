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
    brew install just git git-delta fish stow mise helix uv \
        lazygit fd ripgrep bat eza fzf

# Install fonts
fonts:
    brew install --cask font-iosevka-nerd-font font-iosevka-term-nerd-font

# ── Languages ─────────────────────────────────────────────────────────────────

# Install Node.js LTS + pnpm via corepack (mise)
node:
    mise use -g node@lts
    corepack enable
    corepack prepare pnpm@latest --activate
    mise reshim

# Install Deno (mise)
deno:
    mise use -g deno@latest

# Install Go (mise)
go:
    mise use -g go@latest

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

# Update mise itself
update-mise:
    mise self-update

# Update Node.js to latest LTS + pnpm
update-node:
    mise use -g node@lts
    corepack prepare pnpm@latest --activate
    mise reshim

# Update Deno to latest
update-deno:
    mise use -g deno@latest

# Update Go to latest
update-go:
    mise use -g go@latest

# Update uv itself and install latest Python
update-python:
    uv python install

# Update Rust toolchain
update-rust:
    rustup update

# Update Homebrew packages and remove outdated versions
update-brew:
    brew update
    brew upgrade
    brew cleanup

# Update Claude Code
update-claude:
    claude update

# Update everything
update: update-mise update-node update-deno update-go update-python update-rust update-brew update-claude

# ── Claude Code ───────────────────────────────────────────────────────────────

# Install Claude Code
claude-install:
    curl -fsSL https://claude.ai/install.sh | bash

# Install Claude Code plugins
claude-plugins:
    claude plugin marketplace add obra/superpowers-marketplace && claude plugin install superpowers@superpowers-marketplace
    claude plugin marketplace add thedotmack/claude-mem && claude plugin install claude-mem
    claude plugin marketplace add JuliusBrussee/caveman && claude plugin install caveman@caveman

# Full Claude setup: install + plugins
claude: claude-install claude-plugins

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
