#!/usr/bin/env sh

dotfiles="$HOME/Code/dotfiles"

# Alacritty
ln -svf $dotfiles/.config/alacritty/alacritty.yml $HOME/.config/alacritty/alacritty.yml

# Vim
echo "Setting up nvim..."
ln -svf $dotfiles/.config/nvim/init.vim $HOME/.config/nvim/init.vim 

#Plug 'nvim-telescope/telescope-file-browser.nvim' Tmux
echo "Setting up tmux..."
ln -svf $dotfiles/tmux.conf $HOME/.tmux.conf
