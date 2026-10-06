# List available recipes
default:
    @just --list

# ── Config symlinks ───────────────────────────────────────────────────────────

# Symlink configs to ~ using stow
link:
    cd configs && stow -vt ~ bin dprint fish git gitui helix kitty mise zellij

# Remove config symlinks
unlink:
    cd configs && stow -Dt ~ bin dprint fish git gitui helix kitty mise zellij

# ── Bootstrap ─────────────────────────────────────────────────────────────────

# Install Homebrew
brew:
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install mise
mise-install:
    curl -fsSL https://mise.run | sh
    ~/.local/bin/mise completion fish > configs/fish/.config/fish/completions/mise.fish

# Download zjstatus plugin
zjstatus:
    mkdir -p configs/zellij/.config/zellij/plugins
    curl -fsSL -o configs/zellij/.config/zellij/plugins/zjstatus.wasm https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm

# Install packages, fonts, and symlink configs
setup: mise-install packages fonts zjstatus link

# ── Homebrew packages ─────────────────────────────────────────────────────────

# Install required packages and CLI tools
packages:
    brew install git git-delta fish stow helix uv \
        gitui zellij fd ripgrep bat eza fzf taplo \
        jaq zoxide tealdeer sd mdcat
    brew install --cask kitty

# Dump installed Homebrew packages to Brewfile
brew-dump:
    brew bundle dump --file=Brewfile --force

# Install packages from Brewfile
brew-bundle:
    brew bundle --file=Brewfile --no-lock

# Install fonts
fonts:
    brew install --cask font-iosevka-nerd-font font-iosevka-term-nerd-font

# ── macOS ─────────────────────────────────────────────────────────────────────

# Apply developer-friendly macOS system defaults
macos:
    ./scripts/macos.fish

# Enable Touch ID for sudo (survives macOS updates via sudo_local)
sudo-touchid:
    #!/usr/bin/env -S fish --no-config
    if test -f /etc/pam.d/sudo_local
        echo "Touch ID for sudo is already enabled in /etc/pam.d/sudo_local"
    else
        echo "Enabling Touch ID for sudo (admin password required)..."
        echo "auth       sufficient     pam_tid.so" | sudo tee /etc/pam.d/sudo_local > /dev/null
        sudo chmod 444 /etc/pam.d/sudo_local
        echo "Touch ID for sudo enabled successfully."
    end

# Refresh macOS Dock icon cache
dock-cache:
    rm -f /var/folders/*/*/*/com.apple.dock.iconcache
    killall Dock

# ── Languages & Dev Tooling ───────────────────────────────────────────────────

# Install Node.js LTS + standalone pnpm (mise)
node:
    mise use -g node@lts
    mise use -g pnpm@latest
    mise reshim

# Install frontend tools and LSPs
frontend:
    npm add -g oxlint oxfmt dprint typescript@5 @vtsls/language-server vscode-langservers-extracted yaml-language-server @astrojs/language-server

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
    npm update -g oxlint oxfmt dprint typescript @vtsls/language-server vscode-langservers-extracted yaml-language-server @astrojs/language-server

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
    #!/usr/bin/env -S fish --no-config
    mkdir -p ~/.gnupg
    chmod 700 ~/.gnupg
    set -l prefix (brew --prefix)
    echo "pinentry-program $prefix/bin/pinentry-mac" > ~/.gnupg/gpg-agent.conf
    chmod 600 ~/.gnupg/gpg-agent.conf
    gpgconf --kill gpg-agent

# Generate a new GPG key (interactive)
gpg-generate:
    gpg --full-generate-key

# List secret keys
gpg-list:
    gpg --list-secret-keys --keyid-format=long

# Export public key for git service provider (usage: just gpg-export your@email.com)
gpg-export email:
    gpg --armor --export {{ email }}

# Full GPG setup: install, configure agent, generate key, list keys
gpg-setup: gpg-install gpg-agent gpg-generate gpg-list
