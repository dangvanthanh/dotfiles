#!/usr/bin/env sh

dotfiles="$HOME/Code/dotfiles"
dotfilesConfig="$dotfiles/config"
homeConfig="$HOME/.config"

create_symlink() {
  local src="$1"
  local dest="$2"
  ln -svf "$src" "$dest"
}

link_files() {
  local src_dir="$1"
  local dest_dir="$2"
  shift 2
  local files=("$@")
  
  for file in "${files[@]}"; do
    create_symlink "$src_dir/$file" "$dest_dir/$file"
  done
}

link_folders() {
  local src_dir="$1"
  local dest_dir="$2"
  shift 2
  local folders=("$@")
  
  for folder in "${folders[@]}"; do
    mkdir -p "$dest_dir/$folder"
    for file in "$src_dir/$folder"/*; do
      create_symlink "$file" "$dest_dir/$folder"
    done
  done
}

# Fish
echo "Setting up Fish"
fish="$dotfilesConfig/fish"
fishHome="$homeConfig/fish"
fishFiles=("config.fish" "aliases.fish")
link_files "$fish" "$fishHome" "${fishFiles[@]}"

# Neovim
echo "Setting up Neovim"
nvim="$dotfilesConfig/nvim"
nvimHome="$homeConfig/nvim"
create_symlink "$nvim/init.lua" "$nvimHome/init.lua"
nvimFolders=("lua/config" "lua/plugins")
link_folders "$nvim" "$nvimHome" "${nvimFolders[@]}"

# Alacritty
echo "Setting up Alacritty"
create_symlink "$dotfilesConfig/alacritty/alacritty.toml" "$homeConfig/alacritty/alacritty.toml"

# Bat
echo "Setting up Bat"
create_symlink "$dotfilesConfig/bat/config" "$homeConfig/bat/config"

# Ghostty
echo "Setting up Ghostty"
create_symlink "$dotfilesConfig/ghostty/config" "$homeConfig/ghostty/config"


# Starship
echo "Setting up Starship"
create_symlink "$dotfilesConfig/starship/starship.toml" "$homeConfig/starship.toml"

# Tmux
echo "Setting up Tmux"
create_symlink "$dotfiles/tmux.conf" "$HOME/.tmux.conf"

# Espanso
echo "Setting up Espanso"
espanso="$dotfilesConfig/espanso"
espansoHome="/Users/dangvanthanh/Library/Application Support/espanso"
create_symlink "$espanso/default.yml" "$espansoHome/config/default.yml"

for match in base.yml me.yml nailpro.yml; do
  create_symlink "$espanso/$match" "$espansoHome/match/$match"
done