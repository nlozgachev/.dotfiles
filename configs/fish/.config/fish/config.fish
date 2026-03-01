set -l config_dir (dirname (status --current-filename))/config

source $config_dir/set_shell_vars.fish
source $config_dir/set_aliases.fish
source $config_dir/set_path.fish

# Machine-specific config: env vars, secrets, work tools (not tracked in repo)
# See README for details
if test -f ~/.config/fish/local.fish
    source ~/.config/fish/local.fish
end
