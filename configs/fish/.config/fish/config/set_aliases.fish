alias v=$EDITOR
alias vim=$EDITOR

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

# ── Tool Abbreviations ────────────────────────────────────────────────────────
# Helix
abbr -a helix hx
abbr -a h hx

# GitUI
abbr -a gui gitui

# Zellij
abbr -a zj zellij
abbr -a zja "zellij attach -c"
abbr -a zide "zellij --layout ide"
abbr -a zjl "zellij list-sessions"
abbr -a zjk "zellij kill-session"
abbr -a zjd "zellij delete-all-sessions"

# Just runner
abbr -a j just

# JSON query
abbr -a jq jaq

# Markdown viewer
abbr -a md mdcat

# CLI utilities
alias ls="eza --icons"
alias ll="eza -la --icons --git"
alias lt="eza --tree --icons"
alias cat="bat"
alias find="fd"
