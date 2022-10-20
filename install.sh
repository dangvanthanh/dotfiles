#!/usr/bin/env sh

dotfiles="$HOME/Code/dotfiles"

echo "Setting up Fish"
ln -svf $dotfiles/config/fish/config.fish $HOME/.config/fish/config.fish
echo "Setting up Neovim"
ln -svf $dotfiles/config/nvim/init.vim $HOME/.config/nvim/init.vim
echo "Setting up Alacritty"
ln -svf $dotfiles/config/alacritty/alacritty.yml $HOME/.config/alacritty/alacritty.yml
echo "Setting up Tmux"
ln -svf $dotfiles/tmux.conf $HOME/.tmux.conf
