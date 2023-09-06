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
    "lua/base.lua"
    "lua/highlights.lua"
    "lua/maps.lua"
    "lua/macos.lua"
    "lua/windows.lua"
    "lua/plugins.lua"
    "after/plugin/autopairs.rc.lua"
    "after/plugin/cmp.rc.lua"
    "after/plugin/gitsigns.rc.lua"
    "after/plugin/gruvbox.rc.lua"
    "after/plugin/lspconfig.rc.lua"
    "after/plugin/lspkind.rc.lua"
    "after/plugin/lualine.rc.lua"
    "after/plugin/nvim-tree.rc.lua"
    "after/plugin/prettier.rc.lua"
    "after/plugin/telescope.rc.lua"
    "after/plugin/treesitter.rc.lua"
    "after/plugin/ts-autotag.rc.lua"
    "after/plugin/web-devicons.rc.lua"
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
