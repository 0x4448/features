#!/usr/bin/env bash
set -eu


# Feature Options
VERSION=${VERSION:-"latest"}
HASH=${HASH:-"none"}


# Script Variables
repo="rhysd/actionlint"


# Functions
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
  find . -type f -name actionlint -exec install {} /usr/local/bin/actionlint \;
}


# Main
initialize_tempdir
download
install_feature
