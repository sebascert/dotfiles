if command -v chezmoi >/dev/null 2>&1; then
    source <(chezmoi completion bash)

    dot() { chezmoi "$@"; }
    complete -o default -F __start_chezmoi dot
fi
