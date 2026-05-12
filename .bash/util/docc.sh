DOCC_DIR="${HOME}/docc"
DOCC_REPO="https://github.com/sebascert/docc.git"

docc() {
    local new_docc

    usage() {
        cat <<EOF >&2
Usage:
  docc <doc>

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
        (
            cd "$DOCC_DIR/$new_docc"
            nwin "git status"
        )
        return 0
    fi

    (
        cd "$DOCC_DIR"
        git clone --depth 1 "$DOCC_REPO" "$new_docc" || {
            echo "git clone failed" >&2
            return 2
        }

        cd "$new_docc"
        nwin "nvim src/body.md"
    )
}

_docc_completion() {
    local cur base
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    base="$DOCC_DIR"

    if [[ $COMP_CWORD -eq 1 && -d "$base" ]]; then
        local dirs=() d
        shopt -s nullglob
        for d in "$base"/*/; do
            dirs+=( "${d%/}" )
        done
        shopt -u nullglob

        COMPREPLY=( $(compgen -W "${dirs[*]##*/}" -- "$cur") )
    fi
}

complete -F _docc_completion docc
