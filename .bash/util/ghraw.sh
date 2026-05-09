ghraw() {
    usage() {
        cat <<EOF >&2
Usage: ghraw <github-url>

Download the raw content from a GitHub URL.

Examples:
  ghraw https://github.com/user/repo
      Downloads README.md from the default branch of the repo.

  ghraw https://github.com/user/repo/blob/main/path/to/file.txt
      Downloads the raw file at the specified path.

  ghraw https://gist.github.com/user/hash
      Downloads the raw gist.
EOF
    }

    case $1 in
        -h|--help)
            usage
            return 0
            ;;
    esac

    local url

    if [ -n "$1" ]; then
        url="$1"
    elif ! [ -t 0 ]; then
        read -r url
    else
        usage
        return 1
    fi

    # remove trailing slash if present
    url="${url%/}"

    local user repo branch path raw_url

    if [[ "$url" =~ ^https://github.com/([^/]+)/([^/]+)$ ]]; then
        # repo root URL
        user="${BASH_REMATCH[1]}"
        repo="${BASH_REMATCH[2]}"
        raw_url="https://raw.githubusercontent.com/$user/$repo/HEAD/README.md"
        curl -L "$raw_url"

    elif [[ "$url" =~ ^https://github.com/([^/]+)/([^/]+)/blob/([^/]+)/(.*)$ ]]; then
        # file URL
        user="${BASH_REMATCH[1]}"
        repo="${BASH_REMATCH[2]}"
        branch="${BASH_REMATCH[3]}"
        path="${BASH_REMATCH[4]}"
        raw_url="https://raw.githubusercontent.com/$user/$repo/$branch/$path"
        curl -L "$raw_url"

    elif [[ "$url" =~ ^https://gist.github.com/([^/]+)/([0-9a-fA-F]+) ]]; then
        # gist page URL
        user="${BASH_REMATCH[1]}"
        gist="${BASH_REMATCH[2]}"
        raw_url="https://gist.githubusercontent.com/$user/$gist/raw"
        curl -L "$raw_url"

    else
        echo "Invalid GitHub URL: $url" >&2
        return 1
    fi
}
