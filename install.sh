#!/usr/bin/env sh
set -e

# Configuration
dotfiles="$HOME/Code/dotfiles"
dotfilesConfig="$dotfiles/config"
homeConfig="$HOME/.config"

# Detect OS
detect_os() {
  case "$(uname -s)" in
    Darwin*) echo "macos" ;;
    Linux*)  echo "linux" ;;
    *)       echo "unknown" ;;
  esac
}

OS=$(detect_os)

# OS-specific paths
get_lazygit_config_path() {
  if [ "$OS" = "macos" ]; then
    echo "$HOME/Library/Application Support/lazygit/config.yml"
  else
    echo "$homeConfig/lazygit/config.yml"
  fi
}

# Utility functions
log_info() {
  printf "\033[34m[INFO]\033[0m %s\n" "$1"
}

log_success() {
  printf "\033[32m[OK]\033[0m %s\n" "$1"
}

log_error() {
  printf "\033[31m[ERROR]\033[0m %s\n" "$1" >&2
}

create_symlink() {
  local src="$1"
  local dest="$2"
  
  # Check if source exists
  if [ ! -e "$src" ]; then
    log_error "Source not found: $src"
    return 1
  fi
  
  # Create parent directory if needed
  local dest_dir
  dest_dir=$(dirname "$dest")
  mkdir -p "$dest_dir"
  
  # Create symlink
  if ln -svf "$src" "$dest"; then
    log_success "Linked: $dest -> $src"
  else
    log_error "Failed to link: $dest"
    return 1
  fi
}

link_files() {
  local src_dir="$1"
  local dest_dir="$2"
  shift 2
  
  for file in "$@"; do
    create_symlink "$src_dir/$file" "$dest_dir/$file"
  done
}

link_folder_contents() {
  local src_dir="$1"
  local dest_dir="$2"
  
  mkdir -p "$dest_dir"
  
  for file in "$src_dir"/*; do
    [ -e "$file" ] || continue
    local basename
    basename=$(basename "$file")
    create_symlink "$file" "$dest_dir/$basename"
  done
}

# Main installation
main() {
  log_info "Detected OS: $OS"
  log_info "Starting dotfiles installation..."
  
  # Fish
  log_info "Setting up Fish"
  link_files "$dotfilesConfig/fish" "$homeConfig/fish" \
    "config.fish" "aliases.fish"
  
  # Helix
  log_info "Setting up Helix"
  link_files "$dotfilesConfig/helix" "$homeConfig/helix" \
    "config.toml" "languages.toml" "yazi-picker.fish"
  
  # Zellij
  log_info "Setting up Zellij"
  create_symlink "$dotfilesConfig/zellij/config.kdl" "$homeConfig/zellij/config.kdl"
  link_folder_contents "$dotfilesConfig/zellij/layouts" "$homeConfig/zellij/layouts"

 	# Bat
  log_info "Setting up Bat"
  create_symlink "$dotfilesConfig/bat/config" "$homeConfig/bat/config"
  
  # Ghostty
  log_info "Setting up Ghostty"
  create_symlink "$dotfilesConfig/ghostty/config" "$homeConfig/ghostty/config"
  
  # Yazi
  log_info "Setting up Yazi"
  link_files "$dotfilesConfig/yazi" "$homeConfig/yazi" \
    "yazi.toml" "keymap.toml" "theme.toml"
   
  # Starship
  log_info "Setting up Starship"
  create_symlink "$dotfilesConfig/starship/starship.toml" "$homeConfig/starship.toml"
  
	# Lazygit (OS-specific)
  log_info "Setting up Lazygit"
  local lazygit_dest
  lazygit_dest=$(get_lazygit_config_path)
	create_symlink "$dotfilesConfig/lazygit/config.yml" "$lazygit_dest"
  
  # Opencode
  log_info "Setting up Opencode"
  create_symlink "$dotfilesConfig/opencode/opencode.json" "$homeConfig/opencode/opencode.json"
  log_info "Installation complete!"
}

main "$@"