#!/usr/bin/env fish
set files (yazi --chooser-file=/dev/stdout | cat)
set target_pane $argv[1]

if test -n "$files"
    if test -n "$target_pane"
        zellij action write -p $target_pane 27 # escape-key (ensure normal mode)
        zellij action write-chars -p $target_pane ":open $files"
        zellij action write -p $target_pane 13 # enter-key
    else
        zellij action toggle-floating-panes
        zellij action write 27 # send escape-key
        zellij action write-chars ":open $files"
        zellij action write 13 # send enter-key
        zellij action toggle-floating-panes
    end
end
zellij action close-pane
