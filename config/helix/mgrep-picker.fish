#!/usr/bin/env fish

# Arguments: query
set query "$argv[1]"

if test -z "$query"
    # Open an input prompt using zellij
    zellij action toggle-floating-panes
    zellij action write 27
    zellij action write-chars ":sh echo 'mgrep: No query provided'"
    zellij action write 13
    zellij action toggle-floating-panes
    zellij action close-pane
    exit 1
end

# Run mgrep
set results (mgrep -m 20 -c "$query" . 2>/dev/null)

if test -z "$results"
    zellij action toggle-floating-panes
    zellij action write 27
    zellij action write-chars ":sh echo 'mgrep: No results'"
    zellij action write 13
    zellij action toggle-floating-panes
    zellij action close-pane
    exit 0
end

# Select with fzf
set selected (echo "$results" | fzf --height 100% --layout=reverse --prompt="mgrep: " --delimiter=':' --with-nth=1,2)

if test -n "$selected"
    set file (echo "$selected" | cut -d':' -f1 | string trim)
    set line (echo "$selected" | cut -d':' -f2 | cut -d'-' -f1 | string replace -r '[^0-9]' '' | string trim)

    # Return to Helix and open file
    zellij action toggle-floating-panes
    zellij action write 27 # Escape

    zellij action write-chars ":open $file"
    zellij action write 13 # Enter

    if test -n "$line"
        sleep 0.05
        zellij action write-chars ":goto $line"
        zellij action write 13
    end

    zellij action toggle-floating-panes
end

zellij action close-pane
