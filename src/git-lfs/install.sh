#!/usr/bin/env bash
set -eu


# Feature Options
VERSION=${VERSION:-"3.5.1"}
HASH=${HASH:-"6f28eb19faa7a968882dca190d92adc82493378b933958d67ceaeb9ebe4d731e"}


# Script Variables
fileName="git-lfs.tar.gz"


# Functions
install_requirements() {
  apt update
  apt install --yes --no-install-recommends \
    ca-certificates \
    curl \
    git
}

initialize_tempdir() {
  tempDir=$(mktemp -d)
  cd "$tempDir" || exit 1
  trap 'rm -rf "$tempDir"' EXIT
}

download() {
  url="https://github.com/git-lfs/git-lfs/releases/download/v$VERSION/git-lfs-linux-amd64-v$VERSION.tar.gz"
  curl -fsSL -o "$fileName" "$url"
  if [ "$HASH" != "none" ]; then
    echo "$HASH $fileName" | sha256sum --check
  fi
}

install_feature() {
  tar xf "$fileName"
  install "git-lfs-$VERSION/git-lfs" /usr/local/bin/git-lfs
}


# Main
install_requirements
initialize_tempdir
download
install_feature
