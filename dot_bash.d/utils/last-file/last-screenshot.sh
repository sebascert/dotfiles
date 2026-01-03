last-screenshot(){
    n=${1:-0}
    find ~/Pictures/Screenshots/ -maxdepth 1 -type 'f' | last-file "$n"
}
