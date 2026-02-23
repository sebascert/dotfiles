#!/usr/bin/env bash

# Dependencies:
# docc
# tmux
# git

set -euo pipefail

DOCC_DIR="${HOME}/docc"
DOCC_REPO="https://github.com/sebascert/docc.git"

usage() {
    cat <<EOF >&2
Usage:
  open-docc <doc>

Creates or opens a docc under $DOCC_DIR/<doc> in a new tmux window.
EOF
}

nwin() {
    tmux new-window -n "$new_docc"
    tmux split-window -h
    tmux resize-pane -R 16
    tmux send-keys -t "${new_docc}".0 "$1" C-m
}

case "${1:-}" in
    -h|--help)
        usage
        exit 0
        ;;
esac

[[ $# -eq 1 ]] || {
    echo "missing doc name" >&2
    usage
    exit 1
}

new_docc="$1"

mkdir -p "$DOCC_DIR"

if [[ -d "$DOCC_DIR/$new_docc" ]]; then
    cd "$DOCC_DIR/$new_docc"
    nwin "git status"
    exit 0
fi

cd "$DOCC_DIR"

git clone --depth 1 "$DOCC_REPO" "$new_docc" || {
    echo "git clone failed" >&2
    exit 2
}

cd "$new_docc"
nwin "nvim src/body.md"
