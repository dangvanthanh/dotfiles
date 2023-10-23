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
