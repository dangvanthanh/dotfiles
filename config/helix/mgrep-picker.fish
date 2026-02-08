#!/usr/bin/env fish

set query "$argv[1]"

if test -z "$query"
    echo "Error: No query provided"
    sleep 2
    exit 1
end

# Run mgrep with ALL results (-m 0 or high number, no limit)
# Remove -m flag to get all results, or set very high
set results (mgrep -c "$query" . 2>/dev/null)

if test -z "$results"
    echo "No results for: $query"
    echo "Press any key to close..."
    read -n 1
    exit 0
end

# Count results for display
set count (echo "$results" | wc -l)

# Select with fzf - showing all results with preview
set selected (echo "$results" | fzf \
    --height 100% \
    --layout=reverse \
    --border \
    --prompt="mgrep: $query > " \
    --header="Found $count results | Enter: open | Ctrl-C: cancel" \
    --preview-window=right:60%:wrap \
    --preview='set file (echo {} | cut -d":" -f1); set line (echo {} | cut -d":" -f2 | cut -d"-" -f1 | tr -cd "0-9"); bat --color=always --style=numbers --line-range $line: $file 2>/dev/null || cat $file' \
    --delimiter=':' \
    --with-nth=1,2,3 \
    --ansi)

if test -n "$selected"
    # Parse: ./path/file.ext:line-range(score)
    set file (echo "$selected" | cut -d':' -f1 | string trim)
    set line_range (echo "$selected" | cut -d':' -f2 | cut -d'(' -f1 | string trim)
    set line (echo "$line_range" | cut -d'-' -f1 | string replace -r '[^0-9]' '' | string trim)
    
    # Return to Helix and open file
    zellij action toggle-floating-panes
    zellij action write 27  # Escape
    
    zellij action write-chars ":open $file"
    zellij action write 13  # Enter
    
    if test -n "$line"
        sleep 0.1
        zellij action write-chars ":goto $line"
        zellij action write 13
    end
    
    zellij action toggle-floating-panes
end

zellij action close-pane