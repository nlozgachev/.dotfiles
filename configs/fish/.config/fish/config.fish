set -l config_dir (dirname (status --current-filename))/config

source $config_dir/set_shell_vars.fish
source $config_dir/set_aliases.fish
source $config_dir/set_path.fish

if type -q zoxide
    zoxide init fish | source
end

if test -f ~/.config/fish/local.fish
    source ~/.config/fish/local.fish
end
