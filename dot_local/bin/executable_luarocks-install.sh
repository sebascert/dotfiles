#!/usr/bin/env bash

# Dependencies:
# make
# curl
# tar

set -e

usage() {
    echo "Usage: luarocks-install.sh [luarocks-version]" >&2
}

if [ "$#" -gt 1 ]; then
    usage
    exit 1
fi

luar_version="3.11.1"

[ "$#" -eq 1 ] && luar_version=$1

luar_dir="luarocks-${luar_version}"
luar_tar="${luar_dir}.tar.gz"

curl -L -R -O "https://luarocks.org/releases/$luar_tar"
tar zxpf "$luar_tar"
cd "$luar_dir"
./configure && make && sudo make install

cd ..
rm -rf "$luar_dir"
rm "$luar_tar"
