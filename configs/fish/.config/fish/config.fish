set CURR_FILE (status --current-filename)
set CURR_DIR (dirname $CURR_FILE)
set CONFIGS_DIR $CURR_DIR/config

source $CONFIGS_DIR/set_shell_vars.fish
source $CONFIGS_DIR/set_aliases.fish
source $CONFIGS_DIR/set_path.fish

fnm env --use-on-cd | source

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/fish/__tabtab.fish ]; and . ~/.config/tabtab/fish/__tabtab.fish; or true