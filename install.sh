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

# Summary counters
ok_count=0
fail_count=0

# link_config <src> <dest> [optional]
#
# Wrapper around create_symlink that records each outcome and keeps the
# install going past individual failures, instead of aborting the whole
# script at the first conflict.
link_config() {
  if create_symlink "$@"; then
    ok_count=$((ok_count + 1))
  else
    fail_count=$((fail_count + 1))
  fi
}

# link_folder_contents <src_dir> <dest_dir>
#
# Mirrors every entry of src_dir into dest_dir as a symlink, and prunes
# stale entries: a symlink in dest_dir whose name no longer exists in
# src_dir is removed. Real files/directories in dest_dir are never
# touched — they may be intentional local config — and are only
# reported with a warning. Hidden entries (e.g. .DS_Store) are never
# managed and are left alone.
link_folder_contents() {
  local src_dir="$1"
  local dest_dir="$2"

  # Guard against linking a directory into itself, which would create
  # recursive self-referential symlinks.
  if [ "$src_dir" = "$dest_dir" ]; then
    log_error "Source and destination are the same directory: $src_dir"
    fail_count=$((fail_count + 1))
    return 1
  fi

  if ! mkdir -p "$dest_dir"; then
    fail_count=$((fail_count + 1))
    return 1
  fi

  # Prune stale symlinks whose name no longer exists in src
  local entry name found src_entry
  for entry in "$dest_dir"/*; do
    name=$(basename "$entry")
    case "$name" in
      .*) continue ;;
    esac
    found=0
    for src_entry in "$src_dir"/*; do
      if [ "$(basename "$src_entry")" = "$name" ]; then
        found=1
        break
      fi
    done
    if [ "$found" -eq 0 ]; then
      if [ -L "$entry" ]; then
        if rm -rf "$entry"; then
          log_info "Removed stale link: $entry"
        else
          fail_count=$((fail_count + 1))
        fi
      else
        log_warn "Leaving non-symlink stale entry in dest: $entry"
      fi
    fi
  done

  # Link every source entry (nullglob: an empty src dir links nothing)
  for file in "$src_dir"/*; do
    link_config "$file" "$dest_dir/$(basename "$file")"
  done
}

# Main installation
main() {
  log_info "Detected OS: $(uname -s)"
  log_info "Starting dotfiles installation..."

  # Fish
  log_info "Setting up Fish"
  # secrets.fish is gitignored, so it may not exist on a fresh clone.
  link_config "$dotfilesConfig/fish/config.fish" "$homeConfig/fish/config.fish"
  link_config "$dotfilesConfig/fish/aliases.fish" "$homeConfig/fish/aliases.fish"
  link_config "$dotfilesConfig/fish/secrets.fish" "$homeConfig/fish/secrets.fish" 1

  # Helix
  log_info "Setting up Helix"
  link_config "$dotfilesConfig/helix/config.toml" "$homeConfig/helix/config.toml"
  link_config "$dotfilesConfig/helix/languages.toml" "$homeConfig/helix/languages.toml"
  link_config "$dotfilesConfig/helix/yazi-picker.fish" "$homeConfig/helix/yazi-picker.fish"

  # Zellij
  log_info "Setting up Zellij"
  link_config "$dotfilesConfig/zellij/config.kdl" "$homeConfig/zellij/config.kdl"
  link_folder_contents "$dotfilesConfig/zellij/layouts" "$homeConfig/zellij/layouts"

  # Bat
  log_info "Setting up Bat"
  link_config "$dotfilesConfig/bat/config" "$homeConfig/bat/config"

  # Ghostty
  log_info "Setting up Ghostty"
  link_config "$dotfilesConfig/ghostty/config" "$homeConfig/ghostty/config"

  # Yazi
  log_info "Setting up Yazi"
  link_config "$dotfilesConfig/yazi/yazi.toml" "$homeConfig/yazi/yazi.toml"
  link_config "$dotfilesConfig/yazi/keymap.toml" "$homeConfig/yazi/keymap.toml"
  link_config "$dotfilesConfig/yazi/theme.toml" "$homeConfig/yazi/theme.toml"

  # Starship
  log_info "Setting up Starship"
  link_config "$dotfilesConfig/starship/starship.toml" "$homeConfig/starship.toml"

  # GitUI
  log_info "Setting up GitUI"
  link_config "$dotfilesConfig/gitui/key_bindings.ron" "$homeConfig/gitui/key_bindings.ron"
  link_config "$dotfilesConfig/gitui/theme.ron" "$homeConfig/gitui/theme.ron"

  # Hunk
  log_info "Setting up Hunk"
  link_config "$dotfilesConfig/hunk/config.toml" "$homeConfig/hunk/config.toml"

  # Pi
  log_info "Setting up Pi"
  link_config "$dotfilesConfig/pi/agent/AGENTS.md" "$piHome/agent/AGENTS.md"
  link_config "$dotfilesConfig/pi/agent/AGENTS.LOCAL.md" "$piHome/agent/AGENTS.LOCAL.md" 1
  link_config "$dotfilesConfig/pi/agent/settings.json" "$piHome/agent/settings.json"
  link_config "$dotfilesConfig/pi/agent/mcp.json" "$piHome/agent/mcp.json"
  link_config "$dotfilesConfig/pi/web-search.json" "$piHome/web-search.json" 1
  link_folder_contents "$dotfilesConfig/pi/agent/skills" "$piHome/agent/skills"
  link_folder_contents "$dotfilesConfig/pi/agent/extensions" "$piHome/agent/extensions"
  create_symlink "$dotfilesConfig/pi/agents/semble-search.md" "$piHome/gents/semble-search.md"

  # Summary: never report success on a partial install
  if [ "$fail_count" -gt 0 ]; then
    log_error "Installation finished with $fail_count error(s) ($ok_count OK). Fix and re-run."
    return 1
  fi
  log_success "Installation complete ($ok_count OK)."
}

main "$@"
