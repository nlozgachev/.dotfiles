set -g fish_greeting ""

set -gx EDITOR hx
set -gx TERM xterm-256color
set -gx GPG_TTY (tty)
set -gx PNPM_HOME $HOME/.pnpm-global
set -gx FILMS_DB $HOME/.bin/films.db

set -gx BAT_THEME "base16-256"
set -g fish_color_normal normal
set -g fish_color_command bbdaff
set -g fish_color_quote d1f1a9
set -g fish_color_redirection 99ffff
set -g fish_color_end ebbbff
set -g fish_color_error ff9da4
set -g fish_color_param ffffff
set -g fish_color_comment 7285b7
set -g fish_color_match --background=003f8e
set -g fish_color_selection --background=003f8e
set -g fish_color_search_match --background=003f8e
set -g fish_color_operator 99ffff
set -g fish_color_escape ffeead
set -g fish_color_autosuggestion 7285b7
set -g fish_color_cancel ff9da4
set -g fish_pager_color_prefix bbdaff --bold
set -g fish_pager_color_completion ffffff
set -g fish_pager_color_description 7285b7
set -g fish_pager_color_selected_background --background=003f8e
