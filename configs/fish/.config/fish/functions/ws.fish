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
