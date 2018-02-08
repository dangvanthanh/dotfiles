#!/usr/bin/env sh

dotfiles="$HOME/Code/dev/dotfiles"

# Zshrc
echo "Setting up zsh..."
ln -svf $dotfiles/aliases $HOME/.aliases
ln -svf $dotfiles/zshrc $HOME/.zshrc

# Vim
echo "Setting up nvim..."
ln -svf $dotfiles/init.vim $HOME/.config/nvim/init.vim 

# Tmux
echo "Setting up tmux..."
ln -svf $dotfiles/tmux.conf $HOME/.tmux.conf
