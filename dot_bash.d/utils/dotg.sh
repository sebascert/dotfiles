dotg(){
    local src
    src="$(chezmoi source-path)" || return 1
    (
        cd "$src" || exit 1
        git "$@"
    )
}
