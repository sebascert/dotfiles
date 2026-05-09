last-download() {
    n=${1:-0}
    find ~/Downloads/ -maxdepth 1 -type 'f'| last-file "$n"
}
