#!/usr/bin/env bash
set -eu


# Feature Options
VERSION=${VERSION:-"stable"}
HASH=${HASH:-"none"}


# Script Variables
fileName="shellcheck.tar.xz"


# Functions
install_requirements() {
  apt update
  apt install --yes --no-install-recommends \
    ca-certificates \
    curl \
    xz-utils
}

initialize_tempdir() {
  tempDir=$(mktemp -d)
  cd "$tempDir" || exit 1
  trap 'rm -rf "$tempDir"' EXIT
}

download() {
  url="https://github.com/koalaman/shellcheck/releases/download/$VERSION/shellcheck-$VERSION.linux.$(uname -m).tar.xz"
  curl -fsSL -o "$fileName" "$url"
  if [ "$HASH" != "none" ]; then
    echo "$HASH $fileName" | sha256sum --check
  fi
}

install_feature() {
  tar xf "$fileName"
  install "shellcheck-$VERSION/shellcheck" /usr/local/bin/shellcheck
}


# Main
install_requirements
initialize_tempdir
download
install_feature
