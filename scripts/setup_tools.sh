#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/utils.sh"

enable_strict_mode

usage() {
		echo "Usage: $0 [--all] [--nodejs] [--deno] [--go] [--python] [--rust] [--fish] [--help]"
		echo "Options:"
		echo "  --all      Install all tools"
		echo "  --nodejs   Install Node.js"
		echo "  --deno     Install Deno"
		echo "  --go       Install Go"
		echo "  --python   Install Python"
		echo "  --rust     Install Rust"
		echo "  --fish     Install Fish shell"
		echo "  --help     Display this help message"
		exit 1
}

INSTALL_NODEJS=false
INSTALL_DENO=false
INSTALL_GO=false
INSTALL_PYTHON=false
INSTALL_RUST=false
INSTALL_FISH=false

if [ $# -eq 0 ]; then
	usage
else
		for arg in "$@"; do
				case $arg in
				--nodejs)
						INSTALL_NODEJS=true
						;;
				--deno)
						INSTALL_DENO=true
						;;
				--go)
						INSTALL_GO=true
						;;
				--python)
						INSTALL_PYTHON=true
						;;
				--rust)
						INSTALL_RUST=true
						;;
				--fish)
						INSTALL_FISH=true
						;;
				--all)
						INSTALL_NODEJS=true
						INSTALL_DENO=true
						INSTALL_GO=true
						INSTALL_PYTHON=true
						INSTALL_RUST=true
						INSTALL_FISH=true
						;;
				*)
						usage
						;;
				esac
		done
fi

error_exit() {
		echo "Error: $1" >&2
		exit 1
}

check_success() {
		if ! "$@"; then
				error_exit "Failed to execute: $*"
		fi
}

echo "Installing dependencies..."
check_success brew install curl git asdf

# Node
if [ "$INSTALL_NODEJS" = true ]; then
		echo "Setting up Node.js..."
		check_success asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
		check_success asdf nodejs update-nodebuild
		NODE_LTS=$(asdf nodejs resolve lts --latest-available)
		check_success asdf install nodejs "$NODE_LTS"
		check_success asdf global nodejs "$NODE_LTS"
		check_success corepack enable
		check_success corepack prepare pnpm@latest --activate
		check_success asdf reshim nodejs
fi

# Deno
if [ "$INSTALL_DENO" = true ]; then
		echo "Setting up Deno..."
		check_success asdf plugin-add deno https://github.com/asdf-community/asdf-deno.git
		check_success asdf install deno latest
		check_success asdf global deno latest
fi

# Go
if [ "$INSTALL_GO" = true ]; then
		echo "Setting up Go..."
		check_success asdf plugin add golang https://github.com/asdf-community/asdf-golang.git
		check_success asdf install golang latest
		check_success asdf global golang latest
fi

# Python
if [ "$INSTALL_PYTHON" = true ]; then
		echo "Setting up Python..."
		check_success asdf plugin add python
		check_success asdf install python latest
		check_success asdf global python latest
fi

# Rust
if [ "$INSTALL_RUST" = true ]; then
		echo "Setting up Rust..."
		curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y || error_exit "Failed to install Rust"
fi

# Fish
if [ "$INSTALL_FISH" = true ]; then
		echo "Setting up Fish shell..."
		check_success brew install fish
fi

echo "Selected tools installed successfully"
