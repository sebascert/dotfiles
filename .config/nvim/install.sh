#!/usr/bin/env bash

# Builds and installs Neovim from source for Linux, pinning a specific release,
# then cleans up all build artifacts and the clone.
#
# Dependencies (Ubuntu/Debian):
# ninja-build
# build-essential
# gettext
# cmake
# git
# curl

set -euo pipefail

# sanity checks
if [ $# -ne 1 ]; then
    echo "Missing version" >&2
    exit 1
fi

for cmd in git cmake make curl; do
    command -v "$cmd" >/dev/null 2>&1 || {
        echo "Missing: $cmd" >&2
        exit 1
    }
done

# clean previous installation user files
rm -rf "$HOME/.cache/nvim"
rm -rf "$HOME/.local/share/nvim"
rm -rf "$HOME/.local/state/nvim"

NVIM_VERSION="$1"
TAG="v${NVIM_VERSION}"
REPO_URL="https://github.com/neovim/neovim"
PREFIX="/usr/local"
BUILD_TYPE="Release"

# create temporary workdir
WORKDIR="$(mktemp -d -t nvim-build-XXXXXXXX)"

cleanup() {
    rm -rf "$WORKDIR"
}
trap cleanup EXIT

cd "$WORKDIR"

# download source and build
git clone --depth 1 --branch "$TAG" "$REPO_URL" neovim
cd neovim

make CMAKE_BUILD_TYPE="$BUILD_TYPE"
sudo make CMAKE_INSTALL_PREFIX="$PREFIX" install

# install nvim lazy and mason packages
nvim --headless \
    -c "lua require('lazy').sync({ wait = true, show = false })"\
    -c "MasonUpdate"\
    -c "MasonLockRestore"\
    -c "qa"
