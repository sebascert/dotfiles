EZA_COMPLETION="$HOME/.bash/completion/eza.completion.sh"

if [ ! -f "$EZA_COMPLETION" ];then
    curl -Lo "$EZA_COMPLETION" \
        "https://raw.githubusercontent.com/eza-community/eza/refs/heads/main/completions/bash/eza"
    source "$EZA_COMPLETION"
fi
