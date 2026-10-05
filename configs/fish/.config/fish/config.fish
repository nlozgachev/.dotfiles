set -l config_dir $__fish_config_dir/config

source $config_dir/set_shell_vars.fish
source $config_dir/set_path.fish

if status is-interactive
    source $config_dir/set_aliases.fish

    set -l zoxide_cache "$config_dir/zoxide.fish"
    if test -f "$zoxide_cache"
        source "$zoxide_cache"
    else if type -q zoxide
        zoxide init fish | source
    end

    if test -f ~/.config/fish/local.fish
        source ~/.config/fish/local.fish
    end
end
