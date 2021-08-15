# Dang Thanh’s dotfiles

![](screenshot.png)

## Getting Started

You need install [Git](https://git-scm.com/). Clone or [download](https://github.com/dangvanthanh/dotfiles/archive/master.zip) this repository

```shell $ git clone https://github.com/dangvanthanh/dotfiles.git ``` 
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

## ZSH and Oh My ZSH

Make `zsh` default shell

```shell
$ which zsh
$ chsh -s /bin/zsh
```

Then install Oh My ZSH

```shell
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
$ git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
$ git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
$ echo "source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
$ source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

## Homebrew

Install Homebrew and Brewfile

```shell
$ chmod +x brew.sh
$ ./brew.sh
```

### Brewfile

All the applications I use:

- [Google Chome](https://www.google.com/chrome/) - Chrome Web Browser
- [Firefox](https://www.mozilla.org/en-US/firefox/new/) - Free Web Browser
- [Asciinema](https://asciinema.org/) - Record And Share Terminal
- [Alacritty](https://github.com/jwilm/alacritty) - macOS Terminal Replacement
- [Neovim](https://github.com/neovim/neovim) - Powerful Editor
- [Visual Studio Code](https://code.visualstudio.com/) - Code Editor
- [Sequel Pro](https://www.sequelpro.com/) - Database Management For MySQL
- [Blender](https://www.blender.org/) - Free 3D Creation
- [Dropbox](https://www.dropbox.com/) - Storage Online
- [Skype](https://www.skype.com/en/) - Communication Calls And Chat
- [Rectangle](hhttps://rectangleapp.com/) - Move And Resize Windows

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

Set color scheme for Nevim

```shell
$ curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
$ mkdir -p ~/.config/nvim/colors
$ mv ~/.config/nvim/plugged/gruvbox/colors/gruvbox.vim ~/.config/nvim/colors/gruvbox.vim
```