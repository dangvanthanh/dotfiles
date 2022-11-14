#!/usr/bin/env sh

dotfiles="$HOME/Code/dotfiles"

echo "Setting up Fish"
ln -svf $dotfiles/config/fish/config.fish $HOME/.config/fish/config.fish
echo "Setting up Neovim"
nvim="$dotfiles/config/nvim"
ln -svf $nvim/init.lua $HOME/.config/nvim/init.lua
ln -svf $nvim/lua/base.lua $HOME/.config/nvim/lua/base.lua
ln -svf $nvim/lua/highlights.lua $HOME/.config/nvim/lua/highlights.lua
ln -svf $nvim/lua/maps.lua $HOME/.config/nvim/lua/maps.lua
ln -svf $nvim/lua/macos.lua $HOME/.config/nvim/lua/macos.lua
ln -svf $nvim/lua/windows.lua $HOME/.config/nvim/lua/windows.lua
ln -svf $nvim/lua/plugins.lua $HOME/.config/nvim/lua/plugins.lua
ln -svf $nvim/after/plugin/gruvbox.rc.lua $HOME/.config/nvim/after/plugin/gruvbox.rc.lua
ln -svf $nvim/after/plugin/lualine.rc.lua $HOME/.config/nvim/after/plugin/lualine.rc.lua
echo "Setting up Alacritty"
ln -svf $dotfiles/config/alacritty/alacritty.yml $HOME/.config/alacritty/alacritty.yml
echo "Setting up Tmux"
ln -svf $dotfiles/tmux.conf $HOME/.tmux.conf
