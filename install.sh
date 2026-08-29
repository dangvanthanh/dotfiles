#!/usr/bin/env sh
set -eu

DOTFILES=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

CONFIG="$DOTFILES/config"
XDG_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"
PI_HOME="$HOME/.pi"

AVAILABLE_SETUPS="fish helix zellij bat ghostty yazi starship gitui hunk pi"

if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
  C_INFO='\033[34m'; C_OK='\033[32m'; C_WARN='\033[33m'; C_ERR='\033[31m'; C_RST='\033[0m'
else
  C_INFO=''; C_OK=''; C_WARN=''; C_ERR=''; C_RST=''
fi

info()    { printf "${C_INFO}[INFO]${C_RST} %s\n"  "$1"; }
success() { printf "${C_OK}[OK]${C_RST} %s\n"      "$1"; }
warn()    { printf "${C_WARN}[WARN]${C_RST} %s\n"  "$1"; }
error()   { printf "${C_ERR}[ERROR]${C_RST} %s\n" "$1" >&2; }

die() {
  error "$1"
  exit 1
}

detect_os() {
  case "$(uname -s)" in
    Darwin*) echo "macos" ;;
    Linux*)  echo "linux" ;;
    *)       echo "unknown" ;;
  esac
}

OS=$(detect_os)

backup_path() {
  printf '%s.backup.%s\n' "$1" "$(date '+%Y%m%d-%H%M%S')"
}

link() {
  src=$1
  dest=$2
  optional=${3:-false}

  if [ ! -e "$src" ] && [ ! -L "$src" ]; then
    if [ "$optional" = "true" ]; then
      warn "Optional source missing: $src"
      return 0
    fi
    die "Source missing: $src"
  fi

  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    return 0
  fi

  if [ "$DRY_RUN" = "true" ]; then
    if [ -L "$dest" ]; then
      info "[DRY] relink: $dest -> $src"
    elif [ -e "$dest" ]; then
      info "[DRY] backup + link: $dest -> $src"
    else
      info "[DRY] link: $dest -> $src"
    fi
    return 0
  fi

  mkdir -p "$(dirname "$dest")"

  if [ -L "$dest" ]; then
    rm "$dest"

  elif [ -e "$dest" ]; then
    backup=$(backup_path "$dest")
    warn "Existing path: $dest"
    warn "Backing up to: $backup"
    mv "$dest" "$backup"
  fi

  ln -s "$src" "$dest"
  success "Linked: $dest -> $src"
}

link_config() {
  link "$CONFIG/$1" "$XDG_CONFIG/$1" "${2:-false}"
}

link_pi() {
  link "$CONFIG/pi/$1" "$PI_HOME/$1" "${2:-false}"
}

setup_fish() {
  info "Setting up Fish"
  link_config "fish/config.fish"
  link_config "fish/aliases.fish"
  link_config "fish/secrets.fish" true
}

setup_helix() {
  info "Setting up Helix"
  link_config "helix/config.toml"
  link_config "helix/languages.toml"
  link_config "helix/yazi-picker.fish"
}

setup_zellij() {
  info "Setting up Zellij"
  link_config "zellij/config.kdl"
  link_config "zellij/layouts"
}

setup_bat() {
  info "Setting up Bat"
  link_config "bat/config"
}

setup_ghostty() {
  info "Setting up Ghostty"
  link_config "ghostty/config"
}

setup_yazi() {
  info "Setting up Yazi"
  link_config "yazi/yazi.toml"
  link_config "yazi/keymap.toml"
  link_config "yazi/theme.toml"
}

setup_starship() {
  info "Setting up Starship"
  link "$CONFIG/starship/starship.toml" "$XDG_CONFIG/starship.toml"
}

setup_gitui() {
  info "Setting up GitUI"
  link_config "gitui/key_bindings.ron"
  link_config "gitui/theme.ron"
}

setup_hunk() {
  info "Setting up Hunk"
  link_config "hunk/config.toml"
}

setup_pi() {
  info "Setting up Pi"
  link_pi "agent/AGENTS.md"
  link_pi "agent/AGENTS.LOCAL.md" true
  link_pi "agent/settings.json"
  link_pi "agent/mcp.json"
  link_pi "agents/semble-search.md"
  link_pi "web-search.json"
  link_pi "agent/skills"
  link_pi "agent/extensions"
}

run_setup() {
  name=$1
  fn="setup_$name"
  if ! command -v "$fn" >/dev/null 2>&1; then
    die "Unknown setup: $name (run with --list to see options)"
  fi
  "$fn"
}

usage() {
  cat <<'EOF'
Usage: install.sh [options] [setup ...]

Symlinks dotfiles into place. Without arguments, installs everything.

Options:
  -h, --help     Show this help and exit
  --list         List available setups and exit
  --dry-run      Print intended actions without changing anything
  --no-color     Disable colored output

Setups:
  fish helix zellij bat ghostty yazi starship gitui hunk pi

Examples:
  install.sh                 Install all dotfiles
  install.sh fish helix      Install only Fish and Helix
  install.sh --dry-run       Preview what would be installed
EOF
}

validate() {
  [ "$OS" != "unknown" ] ||
    die "Unsupported operating system: $(uname -s)"

  [ -d "$CONFIG" ] ||
    die "Config directory not found: $CONFIG"
}

main() {
  DRY_RUN=false
  SELECTED=""

  for arg in "$@"; do
    case "$arg" in
      -h|--help)    usage; exit 0 ;;
      --list)      printf '%s\n' $AVAILABLE_SETUPS; exit 0 ;;
      --dry-run)   DRY_RUN=true ;;
      --no-color)  NO_COLOR=1 ;;
      --)          shift; break ;;
      -*)          die "Unknown option: $arg (run with --help)" ;;
      *)           SELECTED="$SELECTED $arg" ;;
    esac
  done

  validate

  info "OS: $OS"
  info "Dotfiles: $DOTFILES"
  info "Config: $CONFIG"
  if [ "$DRY_RUN" = "true" ]; then
    info "Dry-run: no changes will be made"
  fi
  info "Installing dotfiles..."

  if [ -n "$SELECTED" ]; then
    for name in $SELECTED; do run_setup "$name"; done
  else
    for name in $AVAILABLE_SETUPS; do run_setup "$name"; done
  fi

  success "Dotfiles installation complete."
}

main "$@"
