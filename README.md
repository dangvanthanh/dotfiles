# Dang Thanh’s dotfiles

![](screenshot.png)

## Getting Started

You need install [Git](https://git-scm.com/). Clone or [download](https://github.com/dangvanthanh/dotfiles/archive/master.zip) this repository

```shell 
$ git clone https://github.com/dangvanthanh/dotfiles.git
```

### Usage

- `$ cd dotfiles`
- `$ chmod +x install.sh`
- `$ ./install.sh`

## Git

Set Git global configuration

```shell
$ git config --global user.name "Your Name"
$ git config --global user.email "youremail@email.com"
```

## Fish

Make `fish` default shell

```shell
$ which fish
$ chsh -s /opt/homebrew/bin/fish
```

## Homebrew

Install Homebrew and Brewfile

```shell
$ chmod +x brew.sh
$ ./brew.sh
$ ./install.sh
```

## Alacritty and Neovim

Create `~/.config` folder for Alacritty and Neovim

```
$ mkdir ~/.config
$ cd ~/.config
```

### Alacritty

Create configuration for Alacritty

```shell
$ mkdir -p ~/.config/alacritty && cd ~/.config/alacritty && touch alacritty.yml
```

### Neovim

Install the Neovim Python module

```shell
$ pip3 install --user neovim
```

Create configuration for Neovim

```shell
$ mkdir -p ~/.config/nvim && mkdir -p ~/.config/nvim/lua && mkdir -p ~/.config/nvim/lua/config && mkdir -p ~/.config/nvim/lua/plugins
```

Benmark nvim

```shell
$ hyperfine "nvim --headless +qa" --warmup 5
```

#### tsserver

`typescript-language-server` depends on `typescript`. Both packages can be installed via `npm`:

```shell
npm install -g typescript typescript-language-server
```

## Asdf

Update `asdf/shims/node no such file or directory`

```shell
$ vim ~/.asdf/shims/node
```

Or reshim `asdf`

```shell
$ rm -rf ~/.asdf/shims/*
$ asdf reshim
```

## Brewfile

All the applications I use:

#### Web Developer

- [Alacritty](https://github.com/jwilm/alacritty) - macOS Terminal Replacement
- [Neovim](https://github.com/neovim/neovim) - Powerful Editor
- [Visual Studio Code](https://code.visualstudio.com/) - Code Editor
- [Beekeeper Studio](https://www.beekeeperstudio.io/) - The SQL Editor and Database Manager Of Your Dreams
- [SourceTree](https://www.sourcetreeapp.com/) - Simplicity and Ppower in Git GUI
- [Insomnia](https://insomnia.rest/) - The Easy Eay to Design, Debug, and Test APIs
- [Fig](https://fig.io/) - The Next-Generation Command Line

#### Browsers

- [Arc](https://arc.net/) - A New Way of Using the Internet
- [Firefox](https://www.mozilla.org/en-US/firefox/new/) - Fast, Private and Free
- [Google Chome](https://www.google.com/chrome/) - Download the Fast, Security Browser
- [Opera](https://www.opera.com/) - Faster, Safer and Smarter

#### Design

- [Blender](https://www.blender.org/) - Free 3D Creation
- [Inkscape](https://inkscape.org/) - Draw Freely
- [Figma](https://www.figma.com/) - The Collaborative Interface Design Tool

#### Communication

- [Discord](https://discord.com/) - Your Place to Talk and Hang Out
- [Skype](https://www.skype.com/en/) - Communication Calls And Chat
- [Slack](https://slack.com/) - Platform For Team and Work
- [Dropbox](https://www.dropbox.com/) - Storage Online

#### Others

- [Raycast](https://www.raycast.com/) - Blazingly Fast, Totally Extendable Launcher
- [Asciinema](https://asciinema.org/) - Record And Share Terminal
- [Rectangle](https://rectangleapp.com/) - Move And Resize Windows
- [BetterDisplay](https://github.com/waydabber/BetterDisplay) - Unlock Your Displays on Your Mac
- [Bartender](https://www.macbartender.com/Bartender5/) - Take Control of Your Menu Bar
- [NordVPN](https://nordvpn.com/) - Online VPN Service for Speed