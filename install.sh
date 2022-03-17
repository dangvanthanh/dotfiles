#!/usr/bin/env sh

dotfiles="$HOME/Code/dotfiles"

echo "Setting up Neovim + Tmux + Fish + Alacritty"
ln -svf $dotfiles/config/fish/config.fish $HOME/.config/fish/config.fish
ln -svf $dotfiles/config/nvim/init.vim $HOME/.config/nvim/init.vim
ln -svf $dotfiles/config/alacritty/alacritty.yml $HOME/.config/alacritty/alacritty.yml
ln -svf $dotfiles/tmux.conf $HOME/.tmux.conf

echo "Copy fish shell functions"
cp -R $dotfiles/config/fish/functions $HOME/.config/fish
