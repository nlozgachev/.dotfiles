# GO
set -x PATH $PATH $HOME/.go/bin

# DENO
set -x PATH $PATH $HOME/.deno/bin

# NODE
set -x N_PREFIX "$HOME/n"; contains "$N_PREFIX/bin" $PATH; or set -a PATH "$N_PREFIX/bin"
