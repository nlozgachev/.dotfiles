# ── Git Abbreviations ────────────────────────────────────────────────────────
abbr -a g git
abbr -a ga 'git add'
abbr -a gaa 'git add --all'
abbr -a gc 'git commit -m'
abbr -a gcam 'git commit -am'
abbr -a gst 'git status'
abbr -a gd 'git diff'
abbr -a gds 'git diff --staged'
abbr -a gl 'git log --oneline --graph --decorate --all'
abbr -a gp 'git push'
abbr -a gpo 'git push origin'
abbr -a gpl 'git pull'
abbr -a gco 'git checkout'
abbr -a gcb 'git checkout -b'
abbr -a gb 'git branch'
abbr -a gbd 'git branch -d'
abbr -a gcl 'git clone'
abbr -a gsu 'git submodule update --init --recursive'
abbr -a grm 'git rm --cached'
abbr -a gfp 'git fetch --prune'
abbr -a grs 'git reset --soft HEAD~1'
abbr -a grh 'git reset --hard'
abbr -a gcp 'git cherry-pick'
abbr -a gbl 'git blame'
abbr -a glf "git log --pretty=format:'%h - %an, %ar : %s'"

# ── Package Manager Abbreviations ─────────────────────────────────────────────
abbr -a pn pnpm
abbr -a pnd pnpm dev
abbr -a pns pnpm storybook
abbr -a pnt pnpm test:dev

# ── Tools───────────────────────────
alias ed=$EDITOR
alias gg="gitui"
alias md="mdcat"
alias jq="jaq"
alias ls="eza --icons"
alias ll="eza -la --icons --git"
alias lt="eza --tree --icons"
alias cat="bat"
alias find="fd"
