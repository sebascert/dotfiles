last-core() {
    n=${1:-0}
    la core.* | last-file "$n"
}
