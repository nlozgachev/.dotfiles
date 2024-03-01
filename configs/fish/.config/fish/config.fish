set CURR_FILE (status --current-filename)
set CURR_DIR (dirname $CURR_FILE)
set CONFIGS_DIR $CURR_DIR/config

source $CONFIGS_DIR/set_shell_vars.fish
source $CONFIGS_DIR/set_aliases.fish
source $CONFIGS_DIR/set_path.fish
