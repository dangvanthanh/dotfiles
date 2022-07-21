set fish_getting ""
bind \ct kill_word

# Asdf
source /opt/homebrew/opt/asdf/libexec/asdf.fish

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Prince
export PATH="$HOME/Downloads/prince-14.3-macos/lib/prince/bin:$PATH"

# The next line updates PATH for Netlify's Git Credential Helper.
test -f '/Users/dangvanthanh/Library/Preferences/netlify/helper/path.fish.inc' && source '/Users/dangvanthanh/Library/Preferences/netlify/helper/path.fish.inc'
# bun
set -Ux BUN_INSTALL "/Users/dangvanthanh/.bun"
fish_add_path "/Users/dangvanthanh/.bun/bin"

