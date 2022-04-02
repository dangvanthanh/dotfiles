set fish_getting ""
bind \ct kill_word

# Asdf
source /opt/homebrew/opt/asdf/libexec/asdf.fish

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# The next line updates PATH for Netlify's Git Credential Helper.
test -f '/Users/dangvanthanh/Library/Preferences/netlify/helper/path.fish.inc' && source '/Users/dangvanthanh/Library/Preferences/netlify/helper/path.fish.inc'