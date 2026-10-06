function fish_greeting --description "Subtle boxed shell greeting"
    set -l tokens
    set -l plain_tokens

    # 1. Active Workspaces (suppressed if inside a workspace)
    if test -z "$ZELLIJ" -a -z "$ZELLIJ_SESSION_NAME"
        set -l workspaces (zellij list-sessions -s 2>/dev/null)
        if test (count $workspaces) -gt 0
            set -l ws_str (string join ", " $workspaces)
            set -a plain_tokens "ws: $ws_str"
            set -a tokens (echo -s (set_color 7285b7) "ws: " (set_color ffffff) "$ws_str" (set_color normal))
        end
    end

    # 2. Listening Dev Ports
    set -l ports (command lsof -iTCP -sTCP:LISTEN -n -P 2>/dev/null | awk '
NR > 1 && /LISTEN/ {
    cmd = tolower($1);
    split($9, a, ":");
    p = a[length(a)];
    if (p ~ /^[0-9]+$/) {
        is_dev_runtime = (cmd ~ /^(node|bun|deno|python|ruby|go|java|php|rust|uv)/);
        is_dev_port = ((p >= 3000 && p <= 3010) || (p >= 4000 && p <= 4010) || p == 4200 || p == 4321 || (p >= 5001 && p <= 5010) || (p >= 5173 && p <= 5185) || (p >= 8000 && p <= 8010) || (p >= 8080 && p <= 8090) || p == 8888 || p == 9000 || p == 9229);
        is_system = (cmd ~ /^(controlce|rapportd|spotify|sharingd|systemuise|limactl)/ || p == 5000 || p == 7000 || p == 53);
        if (!is_system && (is_dev_runtime || is_dev_port)) {
            print p;
        }
    }
}' | sort -n -u)
    if test (count $ports) -gt 0
        set -l p_str (string join ", " $ports)
        set -a plain_tokens "ports: $p_str"
        set -a tokens (echo -s (set_color 7285b7) "ports: " (set_color ffffff) "$p_str" (set_color normal))
    end

    # 3. Unsynced Commits (only inside git repo with upstream)
    if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
        set -l upstream (command git rev-parse --abbrev-ref '@{upstream}' 2>/dev/null)
        if test -n "$upstream"
            set -l counts (command git rev-list --left-right --count 'HEAD...@{upstream}' 2>/dev/null)
            if test -n "$counts"
                set -l match (string match -r '^(\d+)\s+(\d+)$' -- $counts)
                if test (count $match) -ge 3
                    set -l ahead $match[2]
                    set -l behind $match[3]
                    set -l git_vals
                    test "$ahead" -gt 0; and set -a git_vals "↑$ahead"
                    test "$behind" -gt 0; and set -a git_vals "↓$behind"
                    if test (count $git_vals) -gt 0
                        set -l git_str (string join " " $git_vals)
                        set -a plain_tokens "git: $git_str"
                        set -a tokens (echo -s (set_color 7285b7) "git: " (set_color ffffff) "$git_str" (set_color normal))
                    end
                end
            end
        end
    end

    # Render boxed greeting if any token is present
    if test (count $tokens) -gt 0
        set -l c_line bbdaff
        set -l c_sep  7285b7

        set -l plain_inner (string join "  ·  " $plain_tokens)
        set -l inner_len (string length -- "$plain_inner")
        set -l bar (string repeat -n (math "$inner_len + 2") "─")
        set -l sep (echo -s (set_color $c_sep) "  ·  " (set_color normal))
        set -l rendered_inner (string join "$sep" $tokens)

        echo -s (set_color $c_line) "╭" "$bar" "╮" (set_color normal)
        echo -s (set_color $c_line) "│ " "$rendered_inner" (set_color $c_line) " │" (set_color normal)
        echo -s (set_color $c_line) "╰" "$bar" "╯" (set_color normal)
    end
end
