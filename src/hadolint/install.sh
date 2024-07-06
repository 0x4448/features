#!/usr/bin/env bash
set -eu


# Feature Options
VERSION=${VERSION:-"v2.12.0"}
HASH=${HASH:-"56de6d5e5ec427e17b74fa48d51271c7fc0d61244bf5c90e828aab8362d55010"}


# Script Variables
fileName="hadolint"


# Functions
install_requirements() {
  apt update
  apt install --yes --no-install-recommends \
    ca-certificates \
    curl
}

initialize_tempdir() {
  tempDir=$(mktemp -d)
  cd "$tempDir" || exit 1
  trap 'rm -rf "$tempDir"' EXIT
}

download() {
  url="https://github.com/hadolint/hadolint/releases/download/$VERSION/hadolint-Linux-$(uname -m)"
  curl -fsSL -o "$fileName" "$url"
  if [ "$HASH" != "none" ]; then
    echo "$HASH $fileName" | sha256sum --check
  fi
}

install_feature() {
  install "$fileName" /usr/local/bin/hadolint
}


# Main
install_requirements
initialize_tempdir
download
install_feature
