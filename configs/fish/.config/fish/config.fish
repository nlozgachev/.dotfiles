# GO
set -x PATH $PATH $HOME/.go/bin

#RUST
set -x PATH $PATH $HOME/.cargo/bin

# DENO
set -x PATH $PATH $HOME/.deno/bin

# NODE (via n_installer)
set -x PATH $PATH "$HOME/n/bin"

# NPM & YARN
set -x PATH $PATH "$HOME/.npm"
set -x PATH $PATH "$HOME/.yarn/bin"

set fish_greeting

if status --is-interactive
    abbr -a -g update 'sudo dnf update && flatpak update'
end

set -x N_PREFIX "$HOME/n"; contains "$N_PREFIX/bin" $PATH; or set -a PATH "$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).
