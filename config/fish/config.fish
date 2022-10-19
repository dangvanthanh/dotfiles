set fish_getting ""
bind \ct kill_word

# Asdf
source /opt/homebrew/opt/asdf/libexec/asdf.fish

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Bun
set -Ux BUN_INSTALL "$HOME/.bun"
fish_add_path "$HOME/.bun/bin"

# The next line updates PATH for Netlify's Git Credential Helper.
test -f "$HOME/Library/Preferences/netlify/helper/path.fish.inc" && source "$HOME/Library/Preferences/netlify/helper/path.fish.inc"

# Alias
abbr -a cls "clear"
abbr -a ls "exa --long --header --git"
abbr -a t "tmux"
abbr -a t-kill "tmux kill-server"
abbr -a git-datagap "git config --global user.name 'Dang Van Thanh' && git config --global user.email 'thanh.dang@datagap.io'"
abbr -a git-me "git config --global user.name 'Dang Van Thanh' && git config --global user.email 'dangvanthanh@dangthanh.org'"

# Starship
starship init fish | source