function fish_prompt
    set -l last_status $status

    # ── Tomorrow Night Blue Palette ──────────────────────────────────────────
    set -l c_line bbdaff        # Vibrant Ice Blue for rails, lines & bend
    set -l c_dir  ffffff        # Crisp White for directory
    set -l c_git  ffeead        # Warm Yellow for git branch
    set -l c_ok   d1f1a9        # Pastel Green for success circle
    set -l c_err  ff9da4        # Pastel Red for error circle
    set -l circle "●"

    # ── Directory (single level via Fish builtins, zero process forks) ───────
    set -l dir_str ""
    if test "$PWD" = "$HOME"
        set dir_str "~"
    else if test "$PWD" = "/"
        set dir_str "/"
    else
        set dir_str (path basename "$PWD")
    end

    # ── Git Status (Single git call with --no-optional-locks) ─────────────────
    set -l git_str ""
    set -l lines (git --no-optional-locks status --porcelain=v1 -b 2>/dev/null)
    if test $status -eq 0
        set -l branch (string match -r "^## (?:Initial commit on |No commits yet on )?(\S+?)(?:\.\.\.|\s|\$)" $lines[1])[2]
        test -z "$branch"; and set branch "HEAD"
        set git_str "$branch"
        test (count $lines) -gt 1; and set git_str "$git_str ✗"
    end

    # ── Assemble Top Line ────────────────────────────────────────────────────
    set -l left_rendered (echo -s (set_color $c_line) "╭───── " (set_color -o $c_dir) "$dir_str" (set_color normal))
    set -l left_len (math "7 + " (string length -- "$dir_str"))

    if test -n "$git_str"
        set left_rendered (echo -s "$left_rendered" (set_color $c_line) " ─ " (set_color -o $c_git) "$git_str" (set_color normal))
        set left_len (math "$left_len + 3 + " (string length -- "$git_str"))
    end

    set -l status_color $c_ok
    test $last_status -ne 0; and set status_color $c_err

    set -l cols $COLUMNS
    test -z "$cols"; and set cols 80

    # 7 (╭───── ) + 2 ( ─) + 1 (space) + 1 (●) + 5 ( ────) = 16 fixed chars; target width cols - 1
    set -l fill_count (math "$cols - $left_len - 10")

    if test $fill_count -gt 1
        set -l fill (string repeat -n $fill_count "─")
        echo -s "$left_rendered" (set_color $c_line) " ─$fill " (set_color $status_color) "$circle" (set_color normal) " " (set_color $c_line) "────" (set_color normal)
    else
        echo -s "$left_rendered" (set_color normal)
    end

    # ── Render Bottom Line (Clean Box Bend) ──────────────────────────────────
    set -l prompt_char "╰─ "
    if fish_is_root_user
        set prompt_char "╰─# "
    end

    echo -s (set_color $c_line) "$prompt_char" (set_color normal)
end
