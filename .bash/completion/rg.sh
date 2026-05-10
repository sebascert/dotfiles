if command -v rg >/dev/null 2>&1; then
    eval "$(rg --generate=complete-bash)"
fi
