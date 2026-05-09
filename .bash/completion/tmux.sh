TMUX_COMPLETION="$HOME/.bash/completion/tmux.completion.sh"

if [ ! -f "$TMUX_COMPLETION" ];then
    curl -Lo "$TMUX_COMPLETION" \
        "https://raw.githubusercontent.com/scop/bash-completion/refs/heads/main/completions-core/tmux.bash"
    source "$TMUX_COMPLETION"
fi
