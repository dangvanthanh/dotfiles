#!/usr/bin/env sh

dotfiles="$HOME/Code/dev/dotfiles"

# Zshrc
echo "Setting up zsh...\n"
ln -svf $dotfiles/aliases $HOME/.aliases
ln -svf $dotfiles/zshrc $HOME/.zshrc

# Vim
echo "Setting up vim...\n"
ln -svf $dotfiles/vimrc $HOME/.vimrc
ln -svf $dotfiles/vim $HOME/.vim

# Tmux
echo "Setting up tmux...\n"
ln -svf $dotfiles/tmux.conf $HOME/.tmux.conf

# Hyper
ln -svf $dotfiles/hyper.js $HOME/.hyper.js