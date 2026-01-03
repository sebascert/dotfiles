mkcd(){
    mkdir -p "$*" && cd "$*" || return 1
}
