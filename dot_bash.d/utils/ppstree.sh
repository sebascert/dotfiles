pstack() {
    local pid="${1:-$$}"
    local -a frames=()

    while [ -n "$pid" ] && [ "$pid" -gt 0 ]; do
        local comm ppid
        comm="$(ps -p "$pid" -o comm= 2>/dev/null)" || break
        ppid="$(ps -p "$pid" -o ppid= 2>/dev/null | tr -d ' ')" || break

        frames+=( "$comm|$pid" )
        [ "$pid" = "$ppid" ] && break
        pid="$ppid"
    done

    for (( i=${#frames[@]}-1; i>=0; --i )); do
        IFS='|' read -r comm pid <<< "${frames[i]}"
        printf "%-20s %s\n" "$comm" "$pid"
    done
}
