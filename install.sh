#!/usr/bin/env sh

dotfiles="$HOME/Code/dotfiles"

# Zshrc
echo "Setting up zsh..."
ln -svf $dotfiles/aliases $HOME/.aliases
ln -svf $dotfiles/zshrc $HOME/.zshrc

# Alacritty
ln -svf $dotfiles/alacritty.yml $HOME/.config/alacritty/alacritty.yml

# Vim
echo "Setting up nvim..."
ln -svf $dotfiles/init.vim $HOME/.config/nvim/init.vim 

# Tmux
echo "Setting up tmux..."
ln -svf $dotfiles/tmux.conf $HOME/.tmux.conf
