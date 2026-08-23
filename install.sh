#!/usr/bin/env sh
set -e

# Configuration
dotfiles="$HOME/Code/dotfiles"
dotfilesConfig="$dotfiles/config"
homeConfig="$HOME/.config"
piHome="$HOME/.pi"

# Detect OS
detect_os() {
  case "$(uname -s)" in
    Darwin*) echo "macos" ;;
    Linux*)  echo "linux" ;;
    *)       echo "unknown" ;;
  esac
}

OS=$(detect_os)

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

  # Skip if this is already the correct link (idempotent)
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    return 0
  fi

  # Create parent directory if needed
  local dest_dir
  dest_dir=$(dirname "$dest")
  mkdir -p "$dest_dir"

  rm -rf "$dest"

  # Create symlink
  if ln -s "$src" "$dest"; then
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

  # Guard against linking a directory into itself, which would create
  # recursive self-referential symlinks.
  if [ "$src_dir" = "$dest_dir" ]; then
    log_error "Source and destination are the same directory: $src_dir"
    return 1
  fi

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

  # GitUI
  log_info "Setting up GitUI"
  link_folder_contents "$dotfilesConfig/gitui" "$homeConfig/gitui"

  # Hunk
  log_info "Setting up Hunk"
  create_symlink "$dotfilesConfig/hunk/config.toml" "$homeConfig/hunk/config.toml"
  
  # Pi
  log_info "Setting up Pi"
  create_symlink "$dotfilesConfig/pi/agent/settings.json" "$piHome/agent/settings.json"
  create_symlink "$dotfilesConfig/pi/agent/mcp.json" "$piHome/agent/mcp.json"
  create_symlink "$dotfilesConfig/pi/agents/semble-search.md" "$piHome/agents/semble-search.md"
  create_symlink "$dotfilesConfig/pi/web_search.json" "$piHome/web-search.json"
  link_folder_contents "$dotfilesConfig/pi/agent/skills" "$piHome/agent/skills"
  link_folder_contents "$dotfilesConfig/pi/agent/extensions" "$piHome/agent/extensions"

  log_info "Installation complete!"
}

main "$@"