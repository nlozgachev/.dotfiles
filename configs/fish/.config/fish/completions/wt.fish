# Disable file completions
complete -c wt -f

# Helper: list git branches (local)
function __fish_wt_branches
    set -l root (git rev-parse --show-toplevel 2>/dev/null)
    test -n "$root"; or return
    git branch --format="%(refname:short)" 2>/dev/null
end

# Helper: list existing worktree directory names in .worktrees
function __fish_wt_worktrees
    set -l root (git rev-parse --show-toplevel 2>/dev/null)
    test -n "$root"; or return
    test -d "$root/.worktrees"; and path basename (path filter -d $root/.worktrees/*)
end

# Subcommands
complete -c wt -n "__fish_use_subcommand" -a "ls" -d "List active worktrees"
complete -c wt -n "__fish_use_subcommand" -a "rm" -d "Remove worktree and prune"
complete -c wt -n "__fish_use_subcommand" -a "help" -d "Show usage help"

# wt <branch> (when no subcommand has been given)
complete -c wt -n "__fish_use_subcommand" -a "(__fish_wt_branches)" -d "Branch"

# wt rm <worktree>
complete -c wt -n "__fish_seen_subcommand_from rm remove" -a "(__fish_wt_worktrees)" -d "Worktree"
