export DOTFILES_REPO="$HOME/.dotfiles.git"

dot() {
    git --git-dir="$DOTFILES_REPO" --work-tree="$HOME" "$@"
}

__git_complete dot __git_main
