# Dang Thanh’s dotfiles

I'm forking dotfiles from [Matthias](https://github.com/mathiasbynens/dotfiles/) and [Paul Irish](https://github.com/paulirish/dotfiles)

## Setup

![Dang Thanh's dotfiles](http://i.imgur.com/K4Peh1n.png)

### Install

- You can clone the repository

```
git clone https://github.com/dangvanthanh/dotfiles.git
```

Then `cd` to `dotfiles` and run `bootstrap`

```
cd dotfiles &&  ./bootstrap.sh
```

### Sensible OS X Defaults

```
./.osx
```

### Setup Brew and Application

```
./brew.sh
./brew-cask.sh
```

### Overview to files

### Manual Install
- `bootstrap.sh` - Overwrite files in system
- `brew.sh` - Package manager
- `brew-cask` - Install application

#### Automatic configure
- `.vimrc` - Vim configure
- `.inputrc `

#### Shell Enviroment
- `.aliases`
- `.bash_profile`
- `.bash_prompt`
- `.bashrc`
- `.exports`
- `.functions`
- `.extra`

#### Git
- `.gitattributes`
- `.gitconfig`
- `.gitignore`
