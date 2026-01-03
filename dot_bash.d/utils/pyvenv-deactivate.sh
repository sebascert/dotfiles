# Dependencies:
# python3
# virtualenv

pyvenv-deactivate() {

    if ! deactivate 2> /dev/null; then
        echo "no python virtual environment" >&2
        return 1
    fi

    echo "virtual environment deactivated" >&2
}
