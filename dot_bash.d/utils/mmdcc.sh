# Dependencies:
# mmdc

mmdcc() {
    local PCONF="puppeteer-config.json"

    usage() {
        cat <<EOF >&2
Usage: mmdcc <source.md> [outfile-format] [mmdc-flags]

Arguments:
  source.md         Path to the Markdown diagram source file
  outfile-format    Optional output file format (defaults to png)
  mmdc-flags        Optional flags passed directly to Mermaid CLI

Examples:
  mmdcc diagram.md
  mmdcc diagram.md svg
  mmdcc diagram.md --theme dark
EOF
    }

    local source outformat diagram_file
    local mflags=()

    [[ $# -gt 0 ]] || {
        echo "missing source markdown file" >&2
        usage
        return 1
    }

    source="$1"
    shift

    case "$1" in
        -*)
            ;;
        *)
            outformat="$1"
            shift
            ;;
    esac

    mflags=("$@")

    cd "$(dirname "$source")" || return 1
    diagram_file="$(basename "$source")"

    [[ -z "$outformat" ]] && outformat="png"

    run() {
        mmdc -i "$diagram_file" -e "$outformat" -p "$PCONF" "${mflags[@]}" || {
            echo "failed mmdc compilation" >&2
            return 2
        }
    }

    if [[ -f "$PCONF" ]]; then
        run
    else
        echo '{ "args": ["--no-sandbox"] }' > "$PCONF"
        run
        rm -f "$PCONF"
    fi
}
