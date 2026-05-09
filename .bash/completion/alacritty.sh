ALACRITTY_COMPLETION="$HOME/.bash/completion/alacritty.completion.sh"

if [ ! -f "$ALACRITTY_COMPLETION" ];then
    curl -Lo "$ALACRITTY_COMPLETION" \
        "https://raw.githubusercontent.com/alacritty/alacritty/refs/heads/master/extra/completions/alacritty.bash"
    source "$ALACRITTY_COMPLETION"
fi
