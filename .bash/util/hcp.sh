# dependencies:

hcp() {
    base64 -w0 | awk '{printf "\033]52;c;%s\a", $0}'
}
