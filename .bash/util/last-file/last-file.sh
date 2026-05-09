last-file() {
    n=${1:-0}

    files=()
    while IFS= read -r file; do
        if [ ! -f "$file" ]; then
            echo "invalid file provided  '$file'" >&2
        else
            files+=("$file")
        fi
    done

    if [ ${#files[@]} -eq 0 ]; then
        echo "no files provided." >&2
        exit 1
    fi

    mapfile -t sorted_files < <(ls -1t "${files[@]}" 2>/dev/null)

    # Check if n is valid
    if (( n < 0 || n >= ${#sorted_files[@]} )); then
        echo "invalid n: $n. Provide a value between 0 and ${#sorted_files[@]-1}" >&2
        exit 2
    fi

    echo "${sorted_files[n]}"
}
