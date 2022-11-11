#!/usr/bin/env sh

dotfiles="$HOME/Code/dotfiles"

echo "Setting up Fish"
ln -svf $dotfiles/config/fish/config.fish $HOME/.config/fish/config.fish
echo "Setting up Neovim"
ln -svf $dotfiles/config/nvim/init.lua $HOME/.config/nvim/init.lua
ln -svf $dotfiles/config/nvim/lua/base.lua $HOME/.config/nvim/lua/base.lua
ln -svf $dotfiles/config/nvim/lua/highlights.lua $HOME/.config/nvim/lua/highlights.lua
ln -svf $dotfiles/config/nvim/lua/maps.lua $HOME/.config/nvim/lua/maps.lua
echo "Setting up Alacritty"
ln -svf $dotfiles/config/alacritty/alacritty.yml $HOME/.config/alacritty/alacritty.yml
echo "Setting up Tmux"
ln -svf $dotfiles/tmux.conf $HOME/.tmux.conf
