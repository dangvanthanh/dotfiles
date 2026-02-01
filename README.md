# Dang Thanh’s dotfiles

![Dang Thanh's dotfiles](screenshot.png)

## Getting Started

You need to install [Git](https://git-scm.com/). Clone or [download](https://github.com/dangvanthanh/dotfiles/archive/master.zip) this repository

```shell
git clone https://github.com/dangvanthanh/dotfiles.git
```

### Usage

- `$ cd dotfiles`
- `$ chmod +x install.sh`
- `$ ./install.sh`

## Git

Set Git global configuration

```shell
git config --global user.name "Your Name"
git config --global user.email "youremail@email.com"
```

## Fish

Make `fish` default shell

```shell
which fish
chsh -s /opt/homebrew/bin/fish
```

## Homebrew

Install Homebrew and Brewfile

```shell
chmod +x brew.sh
./brew.sh
./install.sh
```

## Configuration

Create `~/.config` folder for configuration

```shell
mkdir ~/.config && cd ~/.config
```

### Ghostty

Create configuration for Ghostty

```shell
mkdir -p ~/.config/ghostty && touch ~/.config/ghostty/config
```

### Neovim

Install the Neovim Python module

```shell
pip3 install --user neovim
```

Create configuration for Neovim

```shell
mkdir -p ~/.config/nvim
mkdir -p ~/.config/nvim/lua
mkdir -p ~/.config/nvim/lua/config
mkdir -p ~/.config/nvim/lua/plugins
```

Benchmarking Neovim

```shell
hyperfine "nvim --headless +qa" --warmup 5
```

### Starship

Create configuration for Starship

```shell
mkdir -p ~/.config && touch ~/.config/starship.toml
```

## Asdf

Update `asdf/shims/node no such file or directory`

```shell
vim ~/.asdf/shims/node
```

Or reshim `asdf`

```shell
rm -rf ~/.asdf/shims/*
asdf reshim
```

## Brewfile

All the applications I use:

### Web Developer

- [Ghostty](https://ghostty.org/) - macOS Terminal Replacement
- [Helix](https://helix-editor.com/) - Post-modern Text Editor
- [Beekeeper Studio](https://www.beekeeperstudio.io/) - The SQL Editor and Database Manager Of Your Dreams

### TUI
- [Lazygit](https://github.com/jesseduffield/lazygit) - Simple Terminal for Git Commands
- [Posting](https://github.com/darrenburns/posting) - The API Client that Lives in Your Terminal

### Browsers

- [Zen Browsers](https://zen-browser.app) - Beautifully Designed, Privacy-focused
- [Firefox](https://www.mozilla.org/en-US/firefox/new/) - Fast, Private and Free
- [Google Chrome](https://www.google.com/chrome/) - Download the Fast, Security Browser

### Design

- [Figma](https://www.figma.com/) - The Collaborative Interface Design Tool
- [Blender](https://www.blender.org/) - Free 3D Creation
- [Inkscape](https://inkscape.org/) - Draw Freely
- [Darktable](https://darktable.org/) - The Easy Way to Make Great Photos

#### Communication

- [Discord](https://discord.com/) - Your Place to Talk and Hang Out
- [Microsoft Team](https://www.microsoft.com/en-us/microsoft-teams/group-chat-software) - Streamline Communications
- [Dropbox](https://www.dropbox.com/) - Storage Online

#### Others

- [Raycast](https://www.raycast.com/) - Blazingly Fast, Totally Extendable Launcher
- [Asciinema](https://asciinema.org/) - Record And Share Terminal
- [Rectangle](https://rectangleapp.com/) - Move And Resize Windows
- [BetterDisplay](https://github.com/waydabber/BetterDisplay) - Unlock Your Displays on Your Mac
- [Bartender](https://www.macbartender.com/Bartender5/) - Take Control of Your Menu Bar
- [NordVPN](https://nordvpn.com/) - Online VPN Service for Speed
- [Keka](https://www.keka.io/) - Unarchive Files
