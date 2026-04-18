_clip_cmd_complete() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -c -- "$cur") )
}

complete -F _clip_cmd_complete clip

_open_docc_completion() {
    local cur
    cur="${COMP_WORDS[COMP_CWORD]}"

    if [[ $COMP_CWORD -eq 1 ]]; then
        local dirs=()
        if [[ -d "$HOME/docc" ]]; then
            while IFS= read -r -d '' d; do
                dirs+=("$(basename "$d")")
            done < <(find "$HOME/docc" -mindepth 1 -maxdepth 1 -type d -print0 2>/dev/null)
        fi

        COMPREPLY=( $(compgen -W "${dirs[*]} -h --help" -- "$cur") )
    else
        COMPREPLY=()
    fi
}

complete -F _open_docc_completion open-docc.sh
