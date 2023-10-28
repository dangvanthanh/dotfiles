#!/usr/bin/env sh

dotfiles="$HOME/Code/dotfiles"

# Fish
echo "Setting up Fish"
ln -svf $dotfiles/config/fish/config.fish $HOME/.config/fish/config.fish
ln -svf $dotfiles/config/fish/aliases.fish $HOME/.config/fish/aliases.fish

# Neovim
echo "Setting up Neovim"
nvim="$dotfiles/config/nvim"
nvimHome="$HOME/.config/nvim"

files=(
    "init.lua"
    "lua/config/autocmds.lua"
    "lua/config/keymaps.lua"
    "lua/config/lazy.lua"
    "lua/config/options.lua"
    "lua/plugins/alpha.lua"
    "lua/plugins/copilot.lua"
    "lua/plugins/disabled.lua"
    "lua/plugins/gitsigns.lua"
    "lua/plugins/gruvbox.lua"
    "lua/plugins/lsp.lua"
    "lua/plugins/neo-tree.lua"
    "lua/plugins/nvim-cmp.lua"
    "lua/plugins/plugins.lua"
    "lua/plugins/telescope.lua"
    "lua/plugins/treesitter.lua"
)

for file in "${files[@]}"; do
    ln -svf "$nvim/$file" "$nvimHome/$file"
done

# Alacritty
echo "Setting up Alacritty"
ln -svf $dotfiles/config/alacritty/alacritty.yml $HOME/.config/alacritty/alacritty.yml

# Tmux
echo "Setting up Tmux"
ln -svf $dotfiles/tmux.conf $HOME/.tmux.conf