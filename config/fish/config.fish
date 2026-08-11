# Alias
source ~/.config/fish/aliases.fish

# General
set fish_getting ""
set TERM xterm-256color
set EDITOR nvim
bind \ct kill_word

# Starship
starship init fish | source

# Zoxide
zoxide init fish | source

# Path
fish_add_path ~/.local/bin
