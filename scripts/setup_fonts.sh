#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/utils.sh"

enable_strict_mode

echo "Installing fonts using Homebrew..."

check_success brew install font-iosevka-nerd-font font-iosevka-term-nerd-font

echo "Fonts installed successfully!"