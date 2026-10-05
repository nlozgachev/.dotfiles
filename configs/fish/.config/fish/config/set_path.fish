set -gx BUN_INSTALL "$HOME/.bun"

fish_add_path \
    /opt/homebrew/bin \
    /opt/homebrew/sbin \
    $HOME/.bin \
    $HOME/.local/bin \
    $HOME/.cargo/bin \
    $HOME/go/bin \
    $PNPM_HOME \
    $HOME/.local/share/mise/shims

# pnpm
fish_add_path $PNPM_HOME

if status is-interactive
    if type -q mise
        mise activate fish | source
    end

    set -l fzf_cache "$__fish_config_dir/config/fzf.fish"
    if test -f "$fzf_cache"
        source "$fzf_cache"
    else if type -q fzf
        fzf --fish | source
    end
end
