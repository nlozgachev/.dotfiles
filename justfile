# List available recipes
default:
    @just --list

# ── Config symlinks ───────────────────────────────────────────────────────────

# Symlink configs to ~ using stow
link:
    cd configs && stow -vt ~ fish ghostty git helix mise tmux

# Remove config symlinks
unlink:
    cd configs && stow -Dt ~ fish ghostty git helix mise tmux

# ── Bootstrap ─────────────────────────────────────────────────────────────────

# Install Homebrew (run once on a fresh machine before anything else)
brew:
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install mise via official standalone script (brew has outdated versions)
mise-install:
    curl -fsSL https://mise.run | sh
    ~/.local/bin/mise completion fish > configs/fish/.config/fish/completions/mise.fish

# Install packages, fonts, and symlink configs
setup: mise-install packages fonts link

# ── Homebrew packages ─────────────────────────────────────────────────────────

# Install required packages and CLI tools
packages:
    brew install just git git-delta fish stow helix uv \
        lazygit fd ripgrep bat eza fzf taplo

# Install fonts
fonts:
    brew install --cask font-iosevka-nerd-font font-iosevka-term-nerd-font

# ── Languages & Dev Tooling ───────────────────────────────────────────────────

# Install Node.js LTS + standalone pnpm (mise)
node:
    mise use -g node@lts
    mise use -g pnpm@latest
    mise reshim

# Install frontend tools and LSPs for Helix (oxlint, oxfmt, TypeScript LSP, web LSPs)
frontend:
    npm add -g oxlint oxfmt typescript@5 typescript-language-server vscode-langservers-extracted yaml-language-server

# Install Deno (mise)
deno:
    mise use -g deno@latest

# Install Go (mise) + gopls
go:
    mise use -g go@latest
    go install golang.org/x/tools/gopls@latest

# Install latest Python (uv) + ruff & pyright
python:
    uv python install
    uv tool install ruff
    uv tool install pyright

# Install Rust (rustup) + rust-analyzer
rust:
    brew install rustup
    rustup-init -y
    rustup component add rust-analyzer rustfmt

# Install all languages and tooling
langs: node frontend deno go python rust

# ── Updates ───────────────────────────────────────────────────────────────────

# Update mise itself
update-mise:
    mise self-update
    mise completion fish > configs/fish/.config/fish/completions/mise.fish

# Update Node.js to latest LTS + pnpm
update-node:
    mise use -g node@lts
    mise use -g pnpm@latest
    mise reshim

# Update frontend dev tools
update-frontend:
    pnpm update -g oxlint oxfmt typescript typescript-language-server vscode-langservers-extracted yaml-language-server

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

# Update everything
update: update-mise update-node update-frontend update-deno update-go update-python update-rust update-brew

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
