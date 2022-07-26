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