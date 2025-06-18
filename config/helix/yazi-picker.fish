#!/usr/bin/env fish
set files (yazi --chooser-file=/dev/stdout | cat)

if test -n "$files"
    zellij action toggle-floating-panes
    zellij action write 27 # send escape-key
    zellij action write-chars ":open $files"
    zellij action write 13 # send enter-key
    zellij action toggle-floating-panes
end
zellij action close-pane
