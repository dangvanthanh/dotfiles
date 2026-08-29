#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob

# Configuration — the repo root is resolved from the script's own location
# so this works no matter where the repository is cloned.
dotfiles="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dotfilesConfig="$dotfiles/config"
homeConfig="$HOME/.config"
piHome="$HOME/.pi"

# Utility functions
log_info() {
  printf "\033[34m[INFO]\033[0m %s\n" "$1"
}

log_success() {
  printf "\033[32m[OK]\033[0m %s\n" "$1"
}

log_warn() {
  printf "\033[33m[WARN]\033[0m %s\n" "$1" >&2
}

log_error() {
  printf "\033[31m[ERROR]\033[0m %s\n" "$1" >&2
}

# create_symlink <src> <dest> [optional]
#
# Links src -> dest. Never deletes anything that is not a symlink: if
# dest already exists as a real file or directory the script errors and
# leaves it untouched. With [optional] = 1, a missing source only logs
# a warning and the link is skipped.
create_symlink() {
  local src="$1"
  local dest="$2"
  local optional="${3:-0}"

  # Check if source exists
  if [ ! -e "$src" ]; then
    if [ "$optional" -eq 1 ]; then
      log_warn "Optional source not found, skipping: $src"
      return 0
    fi
    log_error "Source not found: $src"
    return 1
  fi

  # Skip if this is already the correct link (idempotent)
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    return 0
  fi

  # Refuse to overwrite non-symlinks (broken symlinks still count as
  # links, so they can be replaced safely).
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    if [ ! -L "$dest" ]; then
      log_error "Refusing to overwrite non-symlink: $dest (move it aside and re-run)"
      return 1
    fi
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

# link_files <src_dir> <dest_dir> <file...>
#
# Links each listed file from src_dir into dest_dir. Files prefixed
# with "?" are optional: when their source is missing they log a
# warning and are skipped instead of aborting the install.
link_files() {
  local src_dir="$1"
  local dest_dir="$2"
  shift 2

  local file name
  for file in "$@"; do
    if [[ "$file" == \?* ]]; then
      name="${file#\?}"
      create_symlink "$src_dir/$name" "$dest_dir/$name" 1
    else
      create_symlink "$src_dir/$file" "$dest_dir/$file"
    fi
  done
}

link_folder_contents() {
  local src_dir="$1"
  local dest_dir="$2"
  local entry basename found src_entry

  # Guard against linking a directory into itself, which would create
  # recursive self-referential symlinks.
  if [ "$src_dir" = "$dest_dir" ]; then
    log_error "Source and destination are the same directory: $src_dir"
    return 1
  fi

  mkdir -p "$dest_dir"

  # Remove stale dest entries whose basename no longer exists in src —
  # but only symlinks. Real files or directories left over in dest are
  # kept with a warning: they may be intentional local configuration.
  for entry in "$dest_dir"/*; do
    basename=$(basename "$entry")
    found=0
    for src_entry in "$src_dir"/*; do
      if [ "$(basename "$src_entry")" = "$basename" ]; then
        found=1
        break
      fi
    done
    if [ "$found" -eq 0 ]; then
      if [ -L "$entry" ]; then
        rm -rf "$entry"
        log_info "Removed stale entry: $entry"
      else
        log_warn "Leaving non-symlink stale entry: $entry"
      fi
    fi
  done

  for file in "$src_dir"/*; do
    basename=$(basename "$file")
    create_symlink "$file" "$dest_dir/$basename"
  done
}

# Main installation
main() {
  log_info "Detected OS: $(uname -s)"
  log_info "Starting dotfiles installation..."

  # Fish
  log_info "Setting up Fish"
  # secrets.fish is gitignored, so it may not exist on a fresh clone —
  # the "?" prefix marks it as optional.
  link_files "$dotfilesConfig/fish" "$homeConfig/fish" \
    "config.fish" "aliases.fish" "?secrets.fish"

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
  create_symlink "$dotfilesConfig/pi/agent/AGENTS.md" "$piHome/agent/AGENTS.md"
  create_symlink "$dotfilesConfig/pi/agent/AGENTS.LOCAL.md" "$piHome/agent/AGENTS.LOCAL.md"
  create_symlink "$dotfilesConfig/pi/agent/settings.json" "$piHome/agent/settings.json"
  create_symlink "$dotfilesConfig/pi/agent/mcp.json" "$piHome/agent/mcp.json"
  create_symlink "$dotfilesConfig/pi/agents/semble-search.md" "$piHome/agents/semble-search.md"
  create_symlink "$dotfilesConfig/pi/web_search.json" "$piHome/web-search.json"
  link_folder_contents "$dotfilesConfig/pi/agent/skills" "$piHome/agent/skills"
  link_folder_contents "$dotfilesConfig/pi/agent/extensions" "$piHome/agent/extensions"

  log_info "Installation complete!"
}

main "$@"
