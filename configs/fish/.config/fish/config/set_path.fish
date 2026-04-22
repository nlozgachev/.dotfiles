# Homebrew
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin
fish_add_path $HOME/.bin
fish_add_path $HOME/.local/bin

# Rust
fish_add_path $HOME/.cargo/bin

# pnpm
fish_add_path $PNPM_HOME

# mise version manager
if status is-interactive
  mise activate fish | source
else
  mise activate fish --shims | source
end

# fzf key bindings and fuzzy completion
fzf --fish | source
