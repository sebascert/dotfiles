##-----------------------------------------------------
## synth-shell-prompt.sh
SYNTH_SHELL_PROMPT="$HOME/.config/synth-shell/synth-shell-prompt.sh"
if [ -f "$SYNTH_SHELL_PROMPT" ] && [ -n "$( echo $- | grep i )" ]; then
    source "$SYNTH_SHELL_PROMPT"
fi
