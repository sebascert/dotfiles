#!/usr/bin/env bash

set -euo pipefail

# Dependencies:
# wmctrl
# x-terminal-emulator

default_term() {
    # Resolve the real binary behind /usr/bin/x-terminal-emulator and return
    # its basename
    readlink -f /usr/bin/x-terminal-emulator | xargs basename
}

open_window() {
    # Focus the window by the name provided. Note that wmctrl may not find the
    # window if its name and class name differ from the name provided.
    #
    # Try by class, then by name.
    local name="$1"

    wmctrl -xa "$name" 2>/dev/null && return 0
    wmctrl -a "$name" 2>/dev/null && return 0

    echo "'$name' window not found" >&2
    return 1
}

term="$(default_term)"
open_window "$term" || exec "$term"
