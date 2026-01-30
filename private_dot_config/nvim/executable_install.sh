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

NVIM_VERSION="0.11.5"
TAG="v${NVIM_VERSION}"
REPO_URL="https://github.com/neovim/neovim"
PREFIX="/usr/local"
BUILD_TYPE="Release"

echo "Building Neovim ${TAG}"
echo

# sanity checks
for cmd in git cmake make curl; do
    command -v "$cmd" >/dev/null 2>&1 || {
        echo "Missing: $cmd" >&2
        exit 1
    }
done

WORKDIR="$(mktemp -d -t nvim-build-XXXXXXXX)"

cleanup() {
    rm -rf "$WORKDIR"
}
trap cleanup EXIT

cd "$WORKDIR"

git clone --depth 1 --branch "$TAG" "$REPO_URL" neovim
cd neovim

make CMAKE_BUILD_TYPE="$BUILD_TYPE"

sudo make CMAKE_INSTALL_PREFIX="$PREFIX" install

make distclean >/dev/null 2>&1 || true

$PREFIX/bin/nvim --version
