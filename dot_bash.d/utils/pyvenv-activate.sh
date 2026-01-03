# Dependencies:
# python3
# virtualenv

venv-activate() {
    local status=""
    local venv_dirs=(".pyvenv" ".venv" "venv")
    local current_dir venv=""

    current_dir="$(pwd)"

    # search upwards for existing venv
    while [ "$current_dir" != "/" ]; do
        for dir in "${venv_dirs[@]}"; do
            if [ -d "$current_dir/$dir" ]; then
                venv="$current_dir/$dir"
                break
            fi
        done

        [ -n "$venv" ] && break
        current_dir="$(dirname "$current_dir")"
    done

    if [ -n "$venv" ]; then
        status="reactivating $venv"
    else
        # create default venv in current directory
        venv="$(pwd)/${venv_dirs[0]}"
        virtualenv "$venv" > /dev/null || return 1
        status="$venv created"
    fi

    source "$venv/bin/activate"

    echo "$status" >&2
}
