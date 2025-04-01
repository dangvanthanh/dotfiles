# Folder and Files
abbr -a cls clear
abbr -a cls-history "builtin history clear"
abbr -a cls-node-modules "find . -name 'node_modules' -type d -prune -print -exec rm -rf '{}' \;"
abbr -a preview "fd --exclude node_modules | fzf --preview 'bat --style=numbers --color=always --line-range :500 {}' | xargs nvim"

# Eza
abbr -a ls eza
abbr -a l "eza -l -g --icons --header --git"
abbr -a lt "eza -1 --icons --tree --git-ignore"
abbr -a li "eza --long --oneline | awk '{print $NF}' | grep -E '\.(jpg|jpeg|png|gif|bmp|tiff|webp|svg)' | xargs -I{} identify -format \"%f: %wx%h\n\" {}"

# Tmux and Neovim
abbr -a vim nvim
abbr -a t tmux
abbr -a tl "tmux split-window -h -p 25"
abbr -a tk "tmux kill-server"
abbr -a port-list "lsof -i :3000"
abbr -a port-kill "kill -9"

# Git
abbr -a git-diff "GIT_EXTERNAL_DIFF=difft git log -p --ext-diff"

# Show/hide files on Macos
abbr -a showFiles "defaults write com.apple.finder AppleShowAllFiles TRUE;killall Finder"
abbr -a hideFiles "defaults write com.apple.finder AppleShowAllFiles NO; killall Finder"

# Utils overrides
abbr -a cat bat
abbr -a find fd

# Homwbrew
abbr -a brew-upgrade "brew update && brew upgrade"