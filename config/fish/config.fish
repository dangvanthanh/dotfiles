set fish_getting ""
bind \ct kill_word

# Asdf
source /opt/homebrew/opt/asdf/libexec/asdf.fish

# Rust
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/binaryen-version_112/bin:$PATH"

# Bun
set -Ux BUN_INSTALL "$HOME/.bun"
fish_add_path "$HOME/.bun/bin"

# Alias
abbr -a cls "clear"
abbr -a ls "exa --long --header --git"
abbr -a t "tmux"
abbr -a t-kill "tmux kill-server"
abbr -a cls-history "builtin history clear"
abbr -a vim "nvim"

# Starship
starship init fish | source

# Pnpm
set -gx PNPM_HOME "$HOME/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end