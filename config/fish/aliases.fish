# Folder and Files
alias cls clear
alias cls-history "builtin history clear"
alias cls-node-modules "find . -name 'node_modules' -type d -prune -print -exec rm -rf '{}' \;"
alias preview "fd --exclude node_modules | fzf --preview 'bat --style=numbers --color=always --line-range :500 {}' | xargs nvim"

# Eza
alias l "eza -l -g --icons --header --git"
alias lt "eza -1 --icons --tree --git-ignore"
alias li "eza --long --oneline | awk '{print $NF}' | grep -E '\.(jpg|jpeg|png|gif|bmp|tiff|webp|svg)' | xargs -I{} identify -format \"%f: %wx%h\n\" {}"

# Tmux and Neovim
alias vim nvim

alias t tmux
alias tl "tmux split-window -h -p 25"
alias tk "tmux kill-server"
alias port-list "lsof -i :3000"
alias port-kill "kill -9"

# Git
alias git-diff "GIT_EXTERNAL_DIFF=difft git log -p --ext-diff"

# Show hidden files on Macos
alias show-all-files "defaults write com.apple.finder AppleShowAllFiles TRUE;killall Finder"