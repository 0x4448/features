#!/usr/bin/env bash
set -eu


# Feature Options
VERSION=${VERSION:-"latest"}
HASH=${HASH:-"none"}


# Script Variables
repo="git-lfs/git-lfs"


# Functions
install_requirements() {
  apt update
  apt install --yes --no-install-recommends \
    ca-certificates \
    curl \
    git \
    jq
}

initialize_tempdir() {
  tempDir=$(mktemp -d)
  cd "$tempDir" || exit 1
  trap 'rm -rf "$tempDir"' EXIT
}

download() {
  if [ "$VERSION" == "latest" ]; then
    urlSuffix="latest"
  else
    urlSuffix="tags/$VERSION"
  fi

  curl -s "https://api.github.com/repos/$repo/releases/$urlSuffix" |
    jq --raw-output \
    '.assets[] | select(.name | contains("linux") and contains("amd64")) | .browser_download_url' |
    xargs curl -fsSL -o FILE

  if [ "$HASH" != "none" ]; then
    echo "$HASH FILE" | sha256sum --check
  fi
}

install_feature() {
  tar xf FILE
  install "$(find . -type f -name git-lfs)" /usr/local/bin/git-lfs
}


# Main
install_requirements
initialize_tempdir
download
install_feature
