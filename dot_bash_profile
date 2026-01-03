# source local env (PATH exports, tokens, etc.)
[ -f "$HOME/.local/bin/env" ] && source "$HOME/.local/bin/env"

# start ssh-agent if not running
if [ -z "${SSH_AGENT_PID:-}" ]; then
    command -v ssh-agent >/dev/null 2>&1 && eval "$(ssh-agent -s)" >/dev/null
fi

# if this is an interactive login shell, also load ~/.bashrc
if [[ $- == *i* ]]; then
    [ -f "$HOME/.bashrc" ] && source "$HOME/.bashrc"
fi
