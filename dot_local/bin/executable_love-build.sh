#!/usr/bin/env bash

# Dependencies:
# git

GAMEDATA="game.dat"

[ -f $GAMEDATA ] && {
    echo "$GAMEDATA is in use, remove it" >&2
    exit 1
}

LOVE_VERSION=$(love --version | sed 's/[^0-9.]//g')

gamename="build"
version="1.0"
version_in_name=false

usage() {
    cat <<EOF >&2
Usage:
  love-build.sh [options]

Options:
  -gamename <name>          Name of the game.
  -v, --version <ver>       Version string of the build.
  -version-in-name          Append the version to the output filename.
EOF
}


while [ "$#" -gt 0 ]; do
    case $1 in
        -gamename)
            gamename=$2
            shift
            ;;
        -v|--version)
            version=$2
            shift
            ;;
        -version-in-name)
            version_in_name=true
            ;;
        *)
            usage
            exit 1
            ;;
    esac
    shift
done

dest_build="$(pwd)/$gamename"
if [ $version_in_name = true ]; then
    dest_build+="_${version}_love_$LOVE_VERSION"
fi
dest_build+=".love"

if [ -f "$dest_build" ]; then
    rm "$dest_build"
fi

echo -e "$gamename \n version: $version \n Love version: $LOVE_VERSION" > $GAMEDATA

# zip files
{ git ls-files; echo $GAMEDATA; } | zip "$dest_build" -@ > /dev/null

rm $GAMEDATA
