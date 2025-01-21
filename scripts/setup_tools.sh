#!/bin/bash

brew install  curl git asdf

#  Node JS
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf nodejs update-nodebuild
asdf install nodejs $(asdf nodejs resolve lts --latest-available)
asdf global nodejs $(asdf nodejs resolve lts --latest-available)
corepack enable
corepack prepare pnpm@latest --activate
asdf reshim nodejs

# Deno
asdf plugin-add deno https://github.com/asdf-community/asdf-deno.git
asdf install deno latest
asdf global deno latest

# Go
asdf plugin add golang https://github.com/asdf-community/asdf-golang.git
asdf install golang latest
asdf global golang latest

# Python
asdf plugin add python
asdf install python latest
asdf global python latest

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh