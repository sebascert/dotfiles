# Dependencies:
# tmux

tmux-new-win() {
    local target="${1:-}"
    local win="<temp>"
    local dir="$PWD"

    if [[ -n "$target" ]]; then
        # Expand ~ (basic) and resolve to absolute path
        target="${target/#\~/$HOME}"
        local abs
        abs="$(cd "$target" 2>/dev/null && pwd)" || {
            echo "not a directory: $1" >&2
            return 1
        }

        dir="$abs"

        # Window name = relative path from ~ (fallback to abs if outside ~)
        if [[ "$abs" == "$HOME" ]]; then
            win="~"
        elif [[ "$abs" == "$HOME/"* ]]; then
            win="${abs#"$HOME"/}"
        else
            win="$abs"
        fi
    fi

    tmux new-window -n "$win" -c "$dir" \; \
        split-window -h -c "$dir" \; \
        resize-pane -R 16
}
