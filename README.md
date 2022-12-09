# Dang Thanh’s dotfiles

![](screenshot.png)

## Getting Started

You need install [Git](https://git-scm.com/). Clone or [download](https://github.com/dangvanthanh/dotfiles/archive/master.zip) this repository

`shell $ git clone https://github.com/dangvanthanh/dotfiles.git `

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
$ which which
$ chsh -s /opt/homebrew/bin/fish
```

## Homebrew

Install Homebrew and Brewfile

```shell
$ chmod +x brew.sh
$ ./brew.sh
```

### Brewfile

All the applications I use:

#### Web Developer

- [Alacritty](https://github.com/jwilm/alacritty) - macOS Terminal Replacement
- [Neovim](https://github.com/neovim/neovim) - Powerful Editor
- [Visual Studio Code](https://code.visualstudio.com/) - Code Editor
- [Table Plus](https://tableplus.com/) - Database Management Easy
- [SourceTree](https://www.sourcetreeapp.com/) - Simplicity and power in Git GUI

#### Browsers

- [Orion](https://browser.kagi.com) - Lightweight, Very Fast and Zero Telemetry
- [Firefox](https://www.mozilla.org/en-US/firefox/new/) - Fast, Private and Free
- [Google Chome](https://www.google.com/chrome/) - Download the Fast, Security Browser

#### Design

- [Blender](https://www.blender.org/) - Free 3D Creation
- [Figma](https://www.figma.com/) - The Collaborative Interface Design Tool

#### Communication

- [Skype](https://www.skype.com/en/) - Communication Calls And Chat
- [Slack](https://slack.com/) - Platform For Team and Work
- [Dropbox](https://www.dropbox.com/) - Storage Online

#### Others

- [Raycast](https://www.raycast.com/) - Blazingly Fast, Totally Extendable Launcher
- [Asciinema](https://asciinema.org/) - Record And Share Terminal
- [Rectangle](https://rectangleapp.com/) - Move And Resize Windows
- [Dozer](https://github.com/Mortennn/Dozer) - Hide menu bar icons on macOS

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
$ mkdir -p ~/.config/nvim && cd ~/.config/nvim && touch init.vim
```

## Asdf

Update `asdf/shims/node no such file or directory`

```shell
$ vim ~/.asdf/shims
```
