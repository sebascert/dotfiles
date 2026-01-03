# Dependencies:
# docc
# tmux
# git

open-docc() {
    local DOCC_DIR="$HOME/docc"
    local DOCC_REPO="git@github.com:sebascert/docc.git"

    usage() {
        cat <<EOF >&2
Usage:
  open-docc <doc>

Creates or opens a docc under $DOCC_DIR/<doc> in a new tmux window.
EOF
    }

    local new_docc
    nwin() {
        tmux new-window -n "$new_docc"
        tmux split-window -h
        tmux resize-pane -R 16
        tmux send-keys -t "$new_docc".0 "$1" C-m
    }

    case "$1" in
        -h|--help)
            usage
            return 0
            ;;
    esac

    [[ $# -eq 1 ]] || {
        echo "missing doc name" >&2
        usage
        return 1
    }

    new_docc="$1"

    mkdir -p "$DOCC_DIR"

    if [[ -d "$DOCC_DIR/$new_docc" ]]; then
        cd "$DOCC_DIR/$new_docc" || return 1
        nwin "git status"
        return 0
    fi

    cd "$DOCC_DIR" || return 1

    git clone "$DOCC_REPO" "$new_docc" || {
        echo "git clone failed" >&2
        return 2
    }

    cd "$new_docc" || return 1
    nwin "nvim src/body.md"
}
