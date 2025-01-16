# Alias
abbr -a cls clear
abbr -a cls-history "builtin history clear"
abbr -a cls-node-modules "find . -name 'node_modules' -type d -prune -print -exec rm -rf '{}' \;"
abbr -a preview "fd --exclude node_modules | fzf --preview 'bat --style=numbers --color=always --line-range :500 {}' | xargs nvim"
abbr -a vscode-plugins "code --list-extensions | xargs -L 1 echo code --install-extension"

# Eza
abbr -a ls "eza -l -g --icons --header --git"
abbr -a ls-tree "eza -1 --icons --tree --git-ignore"
abbr -a ls-images "eza --long --oneline | awk '{print $NF}' | grep -E '\.(jpg|jpeg|png|gif|bmp|tiff|webp|svg)' | xargs -I{} identify -format \"%f: %wx%h\n\" {}"

# Tmux
abbr -a vim nvim
abbr -a list-port "lsof -i :3000"
abbr -a kill-port "kill -9"
abbr -a t tmux
abbr -a t-layout "tmux split-window -h -p 25"
abbr -a t-kill "tmux kill-server"

# Git
abbr -a diff-git "GIT_EXTERNAL_DIFF=difft git log -p --ext-diff"

# Pdf
abbr -a gs-pdf "gs -sDEVICE=pdfwrite -sPAPERSIZE=a4 -dFIXEDMEDIA -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile=output.pdf"

# Show hidden files on macos
abbr -a show-all-files "defaults write com.apple.finder AppleShowAllFiles TRUE;killall Finder"
