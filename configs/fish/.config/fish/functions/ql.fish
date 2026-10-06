function ql --description "Quick Look a file or folder from the terminal"
    if test (count $argv) -eq 0
        echo "Usage: ql <file-or-dir>..."
        return 1
    end
    qlmanage -p $argv >/dev/null 2>&1 &
end
