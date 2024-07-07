#!/usr/bin/env bash
set -eu


# Feature Options
VERSION=${VERSION:-"latest"}
HASH=${HASH:-"none"}


# Script Variables
repo="koalaman/shellcheck"

# Functions
install_requirements() {
  apt update
  apt install --yes --no-install-recommends \
    ca-certificates \
    curl \
    jq \
    xz-utils
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
install_requirements
initialize_tempdir
download
install_feature
