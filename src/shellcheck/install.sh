#!/usr/bin/env bash
set -eu


# Feature Options
VERSION=${VERSION:-"latest"}
HASH=${HASH:-"none"}


# Script Variables
repo="koalaman/shellcheck"

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
    jq --raw-output --arg ARCH "$(uname -m)" \
    '.assets[] | select(.name | contains("linux") and contains($ARCH)) | .browser_download_url' |
    xargs curl -fsSL -o FILE

  if [ "$HASH" != "none" ]; then
    echo "$HASH FILE" | sha256sum --check
  fi
}

install_feature() {
  tar xf FILE
  find . -type f -name shellcheck -exec install {} /usr/local/bin/shellcheck \;
}


# Main
initialize_tempdir
download
install_feature
