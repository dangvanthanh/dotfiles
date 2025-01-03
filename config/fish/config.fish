# Alias
source ~/.config/fish/aliases.fish

# General
set fish_getting ""
bind \ct kill_word

# Asdf
source /opt/homebrew/opt/asdf/libexec/asdf.fish

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Python
export PATH="$HOME/.asdf/installs/python/3.10.4/bin:$PATH"

# Bun
set -Ux BUN_INSTALL "$HOME/.bun"
fish_add_path "$HOME/.bun/bin"

# .NET
export PATH="/usr/local/share/dotnet:$PATH"

# Starship
starship init fish | source

# Pnpm
set -gx PNPM_HOME "$HOME/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end

# Wasmer
export WASMER_DIR="$HOME/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"
# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/dangvanthanh/.cache/lm-studio/bin
