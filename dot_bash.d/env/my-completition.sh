_clip_cmd_complete() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -c -- "$cur") )
}

complete -F _clip_cmd_complete clip
