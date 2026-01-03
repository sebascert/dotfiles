#!/usr/bin/env bash

dir=$(realpath "${1:-.}")

py_sources=$(find "$dir" | grep -v 'venv' | grep '\.py$')

echo "$py_sources" | while read -r source; do
    source_lib=$(realpath "$(dirname "$source")")

    if [ "$source_lib" = "$dir" ]; then
        continue
    fi

    touch "$source_lib/__init__.py"
done
