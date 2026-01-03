#!/usr/bin/env bash

# Dependencies:
# make
# curl
# tar

set -e

usage() {
    echo "Usage: lua-install [lua-version]" >&2
}

if [ "$#" -gt 1 ]; then
    usage
    exit 1
fi

lua_version="5.4.7"

[ "$#" -eq 1 ] && lua_version=$1

lua_dir="lua-${lua_version}"
lua_tar="${lua_dir}.tar.gz"
curl -L -R -O "https://www.lua.org/ftp/$lua_tar"
tar zxf "$lua_tar"
cd "$lua_dir"
make all test

cd src
sudo cp lua /usr/bin
sudo cp luac /usr/bin
sudo cp lua "/usr/bin/lua$lua_version"
sudo cp lua.h /usr/include

cd ../..
rm -rf "$lua_dir"
rm "$lua_tar"
