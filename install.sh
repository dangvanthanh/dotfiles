#!/usr/bin/env sh

dotfiles="$HOME/Code/dev/dotfiles"

# zshrc
echo "Setting up zsh...\n"
ln -svf $dotfiles/aliases $HOME/.aliases
ln -svf $dotfiles/zshrc $HOME/.zshrc

# vim
echo "Setting up vim...\n"
ln -svf $dotfiles/vimrc $HOME/.vimrc
ln -svf $dotfiles/vim $HOME/.vim

# tmux
echo "Setting up tmux...\n"
ln -svf $dotfiles/tmux.conf $HOME/.tmux.conf

# hyper
ln -svf $dotfiles/hyper.js $HOME/.hyper.js