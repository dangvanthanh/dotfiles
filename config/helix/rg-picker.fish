#!/usr/bin/env fish
set query (read -P "rg: ")

if test -n "$query"
    set file (rg --line-number --color=never "$query" | fzf --delimiter=':' --with-nth=1,2,3 | cut -d':' -f1,2)
    if test -n "$file"
        set path (echo $file | cut -d':' -f1)
        set line (echo $file | cut -d':' -f2)
        zellij action toggle-floating-panes
        zellij action write 27
        zellij action write-chars ":open $path"
        zellij action write 13
        zellij action write-chars ":goto $line"
        zellij action write 13
        zellij action toggle-floating-panes
    end
end
zellij action close-pane