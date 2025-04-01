# Alias
source ~/.config/fish/aliases.fish

# General
set fish_getting ""
set TERM xterm-256color
set EDITOR nvim
bind \ct kill_word

set -Ux BUN_INSTALL "$HOME/.bun"
set -gx PNPM_HOME "$HOME/Library/pnpm"
set -gx LDFLAGS "-L/opt/homebrew/opt/icu4c@76/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/icu4c@76/include"
set -gx PKG_CONFIG_PATH "/opt/homebrew/opt/icu4c@76/lib/pkgconfig"

# Path
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/usr/local/share/dotnet:$PATH"
export WASMER_DIR="$HOME/.wasmer"

[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"

fish_add_path "/opt/homebrew/opt/icu4c@76/bin"
fish_add_path "/opt/homebrew/opt/icu4c@76/sbin"
fish_add_path "/Users/dangvanthanh/.codeium/windsurf/bin"
fish_add_path "$HOME/.bun/bin"

# Asdf
if test -z $ASDF_DATA_DIR
    set _asdf_shims "$HOME/.asdf/shims"
else
    set _asdf_shims "$ASDF_DATA_DIR/shims"
end

# Pnpm
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end

# Starship
starship init fish | source

# Zoxide
zoxide init fish | source
