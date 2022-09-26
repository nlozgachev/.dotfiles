volta:
	curl https://get.volta.sh | bash

node: volta
	volta install node@lts

node_pkgs: volta
	volta install npm yarn pnpm prettier all-the-package-names

deno:
	curl -fsSL https://deno.land/x/install/install.sh | sh

go:
	curl -LO https://get.golang.org/$(uname)/go_installer && chmod +x go_installer && ./go_installer && rm go_installer

homebrew:
	bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

homebrew_pkgs: homebrew
	brew install git fish neovim stow

homebrew_langs: homebrew
	brew install rustup-init go python

homebrew_fonts: homebrew
	brew install --cask font-iosevka

setup_common: volta node node_pkgs

setup_macos: homebrew homebrew_pkgs homebrew_fonts setup_common

# migrate to Nix?