# Dotfiles

## Installation

Clone repo.

```bash
git clone --bare git@github.com:sebascert/.dotfiles.git ~/.dotfiles.git
```

Setup repo.

```bash
DOT="git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME"
$DOT config --local status.showUntrackedFiles no
$DOT config --local core.excludesFile ~/.dotfiles.gitignore
$DOT checkout
```

Source configs.

```bash
source ~/.bashrc
```
