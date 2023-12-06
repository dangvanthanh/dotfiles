#!/usr/bin/env sh

dotfiles="$HOME/Code/dotfiles"

# Fish
echo "Setting up Fish"
fish="$dotfiles/config/fish"
fishHome="$HOME/.config/fish"
fishFiles=(
  "config.fish"
  "aliases.fish"
)

for file in "${nvimFiles[@]}"; do
  ln -svf "$nvim/$file" "$nvimHome/$file"
done

# Neovim
echo "Setting up Neovim"
nvim="$dotfiles/config/nvim"
nvimHome="$HOME/.config/nvim"

folders=(
  "lua/config"
  "lua/plugins"
)

for folder in "${folders[@]}"; do
  mkdir -p "$nvimHome/$folder"
done

link_folder() {
  local src_folder="$1"
  local dest_folder="$2"
  
  for file in "$nvim/$src_folder"/*; do
    ln -svf "$file" "$nvimHome/$dest_folder"
  done
}

ln -svf "$nvim/init.lua" "$nvimHome/init.lua"

for folder in "${folders[@]}"; do
  link_folder "$folder" "$folder"
done

# Alacritty
echo "Setting up Alacritty"
ln -svf $dotfiles/config/alacritty/alacritty.yml $HOME/.config/alacritty/alacritty.yml

# Wezterm
echo "Setting up WezTerm"
ln -svf $dotfiles/config/wezterm/wezterm.lua $HOME/.wezterm.lua

# Tmux
echo "Setting up Tmux"
ln -svf $dotfiles/tmux.conf $HOME/.tmux.conf

# Bat
echo "Setting up Bat"
ln -svf $dotfiles/config/bat/config $HOME/.config/bat/config