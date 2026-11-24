# dependencies:

ccp() {
    base64 | tr -d '\n' | awk '{printf "\033]52;c;%s\a", $0}'
}

cpt() {
    local r
    printf '\e]52;c;?\a' > /dev/tty
    IFS= read -rs -t2 -d $'\a' r < /dev/tty &&
    printf '%s' "${r##*;}" | base64 -d
}
