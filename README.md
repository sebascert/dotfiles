# Dotfiles

Quick install from your home directory (requires Git and curl):

```bash
git clone --bare https://github.com/sebascert/dotfiles.git .dotfiles.git &&
git --git-dir=.dotfiles.git --work-tree=. checkout &&
./dotinstall.sh
```

## What dotinstall.sh installs

- Dotfiles setup
- Homebrew and [CLI tools](.config/packages/Brewfile)
- Man pages supplied by packages
- Rust toolchain
- NVM and Node.js LTS
- [npm tools](.config/packages/npm.txt)
- [pipx tools](.config/packages/pipx.txt)
- Neovim plugins and locked language tools
- TPM and [tmux plugins](.tmux.conf)
- Synth-Shell prompt

## Manual installation

These tools are excluded from `dotinstall.sh`; follow their installation guides:

- [Alacritty](https://github.com/alacritty/alacritty/blob/master/INSTALL.md)
- [Wikiman](https://github.com/filiparag/wikiman#installation)
