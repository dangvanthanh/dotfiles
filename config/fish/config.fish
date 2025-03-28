# Alias
source ~/.config/fish/aliases.fish

# General
set fish_getting ""
bind \ct kill_word

# Asdf
if test -z $ASDF_DATA_DIR
    set _asdf_shims "$HOME/.asdf/shims"
else
    set _asdf_shims "$ASDF_DATA_DIR/shims"
end

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

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

# Icu4c
fish_add_path "/opt/homebrew/opt/icu4c@76/bin"
fish_add_path "/opt/homebrew/opt/icu4c@76/sbin"

set -gx LDFLAGS "-L/opt/homebrew/opt/icu4c@76/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/icu4c@76/include"
set -gx PKG_CONFIG_PATH "/opt/homebrew/opt/icu4c@76/lib/pkgconfig"
# Added by Windsurf
fish_add_path /Users/dangvanthanh/.codeium/windsurf/bin
