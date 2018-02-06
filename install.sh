#!/usr/bin/env sh

dotfiles="$HOME/Code/dev/dotfiles"

# Zshrc
echo "Setting up zsh...\n"
ln -svf $dotfiles/aliases $HOME/.aliases
ln -svf $dotfiles/zshrc $HOME/.zshrc

# Vim
echo "Setting up nvim...\n"
ln -svf $dotfiles/init.vim $HOME/.config/init.vim

# Tmux
echo "Setting up tmux...\n"
ln -svf $dotfiles/tmux.conf $HOME/.tmux.conf
