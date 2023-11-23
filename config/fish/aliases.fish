# Alias
abbr -a cls clear
abbr -a ls "exa -l -g --icons --header --git"
abbr -a llt "exa -1 --icons --tree --git-ignore"
abbr -a t tmux
abbr -a t-kill "tmux kill-server"
abbr -a cls-history "builtin history clear"
abbr -a vim nvim
abbr -a clean-node-modules "find . -name 'node_modules' -type d -prune -print -exec rm -rf '{}' \;"
abbr -a preview "fzf --preview 'bat --style=numbers --color=always --line-range :500 {}' | xargs nvim"
abbr -a code-plugins "code --list-extensions | xargs -L 1 echo code --install-extension"
abbr -a list-port "lsof -i :3000"
abbr -a kill-port "kill -9"
abbr -a difft-git "GIT_EXTERNAL_DIFF=difft git log -p --ext-diff"