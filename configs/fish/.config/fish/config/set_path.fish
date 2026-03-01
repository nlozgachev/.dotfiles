# Homebrew
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin
fish_add_path $HOME/.bin

# Rust
fish_add_path $HOME/.cargo/bin

# pnpm
fish_add_path $PNPM_HOME

# asdf version manager
source /opt/homebrew/opt/asdf/libexec/asdf.fish

# Go environment (via asdf-golang plugin)
source ~/.asdf/plugins/golang/set-env.fish
