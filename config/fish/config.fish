# Alias
source ~/.config/fish/aliases.fish

# General
set fish_getting ""
set TERM xterm-256color
set EDITOR nvim
bind \ct kill_word

# Path
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/usr/local/share/dotnet:$PATH"
export WASMER_DIR="$HOME/.wasmer"

[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"

# Starship
starship init fish | source

# Zoxide
zoxide init fish | source
