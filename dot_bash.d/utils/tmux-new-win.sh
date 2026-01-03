# Dependencies:
# tmux

tmux-new-win(){
    tmux new-window -n "$@" \; split-window -h \; resize-pane -R 16
}
