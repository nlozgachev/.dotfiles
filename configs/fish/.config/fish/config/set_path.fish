# Homebrew
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin
fish_add_path $HOME/.bin

# Rust
fish_add_path $HOME/.cargo/bin

# PNPM
fish_add_path $PNPM_HOME

source /opt/homebrew/opt/asdf/libexec/asdf.fish
source ~/.asdf/plugins/golang/set-env.fish
source ~/.asdf/plugins/java/set-java-home.fish

