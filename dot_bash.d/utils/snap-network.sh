# Dependencies
# snap

snap-network(){
    action="$1"
    package="$2"

    sudo snap "$action" "$package":network
}

_toggle_snap_network_completions() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local opts="connect disconnect"

    COMPREPLY=($(compgen -W "$opts" -- "$cur"))
}

complete -F _toggle_snap_network_completions snap-network
