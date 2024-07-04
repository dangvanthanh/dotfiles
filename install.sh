#!/usr/bin/env sh

dotfiles="$HOME/Code/dotfiles"
dotfilesConfig="$dotfiles/config"
homeConfig="$HOME/.config"

# Fish
echo "Setting up Fish"
fish="$dotfilesConfig/fish"
fishHome="$homeConfig/fish"
fishFiles=(
  "config.fish"
  "aliases.fish"
)

for file in "${fishFiles[@]}"; do
  ln -svf "$fish/$file" "$fishHome/$file"
done

# Neovim
echo "Setting up Neovim"
nvim="$dotfilesConfig/nvim"
nvimHome="$homeConfig/nvim"

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
ln -svf $dotfilesConfig/alacritty/alacritty.toml $homeConfig/alacritty/alacritty.toml

# Tmux
echo "Setting up Tmux"
ln -svf $dotfiles/tmux.conf $HOME/.tmux.conf

# Bat
echo "Setting up Bat"
ln -svf $dotfilesConfig/bat/config $homeConfig/bat/config

# Navi
echo "Setting up Navi"
ln -svf $dotfilesConfig/navi/config.yaml $homeConfig/navi/config.yaml