nvalgrind() {
    local vgout=".vgout"

    local -a vgflags=(
        --leak-check=full
        --show-leak-kinds=all
        --track-fds=yes
        --log-file="$vgout"
    )

    usage() {
        cat <<EOF >&2
Usage: nvalgrind [options] -- [vgargs...] <program> [args...]

Runs valgrind with sane defaults and opens the report in Neovim.
Everything after '--' is passed directly to valgrind.

Options:
  -h, --help        Show this help message
EOF
    }

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                usage
                return 0
                ;;
            --)
                shift
                break
                ;;
            *)
                echo "Unknown option: $1" >&2
                return 1
                ;;
        esac
    done

    valgrind "${vgflags[@]}" "$@" <&0
    local rc=$?
    (( rc == 0 )) || return "$rc"

    nvim -c 'set ft=valgrind wrap' "$vgout" </dev/tty >/dev/tty 2>/dev/tty
}
