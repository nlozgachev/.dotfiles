function cleanup-dsstore --description "Recursively remove .DS_Store files from current directory"
    set -l count (command find . -name '.DS_Store' -type f | wc -l | string trim)
    if test "$count" -gt 0
        command find . -name '.DS_Store' -type f -delete
        echo "Cleaned up $count .DS_Store file(s)."
    else
        echo "No .DS_Store files found."
    end
end
