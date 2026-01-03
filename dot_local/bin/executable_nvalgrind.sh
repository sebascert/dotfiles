#!/usr/bin/env bash

# Dependencies:
# nvim
# valgrind

set -euo pipefail

VGOUT=".vgout"
VGFLAGS=(
    --leak-check=full
    --show-leak-kinds=all
    --track-fds=yes
    --log-file="$VGOUT"
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
            exit 0
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
    esac
done

valgrind "${VGFLAGS[@]}" "$@" <&0

exec </dev/tty >/dev/tty 2>/dev/tty

nvim -c 'set ft=valgrind wrap' "$VGOUT"
