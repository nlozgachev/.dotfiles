alias ed=$EDITOR

alias g="git"
alias ga="git add"
alias gaa="git add --all"
alias gc="git commit -m"
alias gcam="git commit -am"
alias gst="git status"
alias gd="git diff"
alias gds="git diff --staged"
alias gl="git log --oneline --graph --decorate --all"
alias gp="git push"
alias gpo="git push origin"
alias gpl="git pull"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gb="git branch"
alias gbd="git branch -d"
alias gcl="git clone"

alias gsu="git submodule update --init --recursive"
alias grm="git rm --cached"
alias gfp="git fetch --prune"
alias grs="git reset --soft HEAD~1"
alias grh="git reset --hard"
alias gcp="git cherry-pick"
alias gbl="git blame"
alias glf="git log --pretty=format:'%h - %an, %ar : %s'"

# ── Package Manager Abbreviations ─────────────────────────────────────────────
abbr -a pn pnpm
abbr -a pnd pnpm dev
abbr -a pns pnpm storybook
abbr -a pnt pnpm test:dev

# ── Tools ──────────────────────────────────────────────────
alias gg="gitui"
alias md="mdcat"
alias jq="jaq"

function ws --description "Workspace manager: resume latest session or attach/create named session"
    if test (count $argv) -gt 0
        switch $argv[1]
            case ls list
                zellij list-sessions
            case k kill
                if test (count $argv) -gt 1
                    zellij kill-session $argv[2]
                else
                    zellij kill-session
                end
            case da "delete-all"
                zellij delete-all-sessions
            case "-*"
                zellij $argv
            case '*'
                zellij attach -c $argv[1]
        end
    else
        set -l sessions (zellij list-sessions -s 2>/dev/null)
        if test (count $sessions) -gt 0
            zellij attach $sessions[1]
        else
            zellij
        end
    end
end

alias ls="eza --icons"
alias ll="eza -la --icons --git"
alias lt="eza --tree --icons"
alias cat="bat"
alias find="fd"
