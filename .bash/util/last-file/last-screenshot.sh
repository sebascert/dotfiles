last-screenshot(){
    n=${1:-0}
    find ~/media/screenshots/ -maxdepth 1 -type 'f' | last-file "$n"
}
