export PATH=$HOME/.toolbox/bin:$PATH

# Added by AIM CLI
export PATH="$HOME/.aim/mcp-servers:$PATH"

# Homebrew: macOS (Apple Silicon / Intel) or Linuxbrew, whichever exists
for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew "$HOME/.linuxbrew/bin/brew"; do
    if [[ -x "$_brew" ]]; then
        eval "$("$_brew" shellenv)"
        break
    fi
done
unset _brew

# Set up mise for runtime management
command -v mise >/dev/null 2>&1 && eval "$(mise activate bash)"

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path bash)"
