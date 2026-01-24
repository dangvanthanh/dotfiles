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

# Helix
echo "Setting up Helix"
helix="$dotfilesConfig/helix"
helixHome="$homeConfig/helix"
helixFiles=("config.toml" "languages.toml" "yazi-picker-.fish")

link_files "$helix" "$helixHome" "${helixFiles[@]}"

# Zellij
echo "Setting up Zellij"
zellij="$dotfilesConfig/zellij"
zellijHome="$homeConfig/zellij"
zellijFolders=("layouts" "themes")
create_symlink "$zellij/config.kdl" "$zellijHome/config.kdl"
link_folders "$zellij" "$zellijHome" "${zellijFolders[@]}"

# Bat
echo "Setting up Bat"
bat="$dotfilesConfig/bat"
batHome="$homeConfig/bat"
create_symlink "$bat/config" "$batHome/config"

# Ghostty
echo "Setting up Ghostty"
ghostty="$dotfilesConfig/ghostty"
ghosttyHome="$homeConfig/ghostty"
create_symlink "$ghostty/config" "$ghosttyHome/config"

# Yazi
echo "Setting up Yazi"
yazi="$dotfilesConfig/yazi"
yaziHome="$homeConfig/yazi"
yaziFiles=("yazi.toml" "keymap.toml" "theme.toml")
link_files "$yazi" "$yaziHome" "${yaziFiles[@]}"

# Starship
echo "Setting up Starship"
starship="$dotfilesConfig/starship"
create_symlink "$starship/starship.toml" "$homeConfig/starship.toml"

# Lazygit
echo "Setting up Lazygit"
lazygit="$dotfilesConfig/lazygit"
create_symlink "$lazygit/config.yml" "$HOME/Library/Application Support/lazygit/config.yml"
