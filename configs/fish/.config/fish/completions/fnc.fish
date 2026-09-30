# Disable file completions
complete -c fnc -f

# Subcommands
complete -c fnc -n "__fish_use_subcommand" -a "branch" -d "Create conventional branch"
complete -c fnc -n "__fish_use_subcommand" -a "commit" -d "Create conventional commit"
complete -c fnc -n "__fish_use_subcommand" -a "help" -d "Show usage help"