#!/usr/bin/env bash
set -eu


# Feature Options
VERSION=${VERSION:-"latest"}
DOTNET=${DOTNET:-"false"}
HASH=${HASH:-"none"}


# Script Variables
repo="godotengine/godot"


# Functions
install_requirements() {
  apt update
  apt install --yes --no-install-recommends \
    ca-certificates \
    curl \
    jq \
    unzip
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
    urlSuffix="tags/$VERSION-stable"
  fi

  if [ "$DOTNET" == "true" ]; then
    build="stable_mono_linux"
  else
    build="stable_linux"
  fi

  curl -s "https://api.github.com/repos/$repo/releases/$urlSuffix" |
    jq --raw-output --arg ARCH "$(uname -m)" --arg BUILD "$build" \
    '.assets[] | select(.name | contains($BUILD) and contains($ARCH)) | .browser_download_url' |
    xargs curl -fsSL -o FILE

  if [ "$HASH" != "none" ]; then
    echo "$HASH FILE" | sha256sum --check
  fi
}

install_feature() {
  unzip FILE

  if [ "$DOTNET" == "true" ]; then
    find . -type d -name "Godot_*" -exec cp -r {} /usr/local/godot \;
    find /usr/local/godot -type f -name "Godot_*$(uname -m)" -exec mv {} /usr/local/godot/godot \;
    chmod +x /usr/local/godot/godot
    ln -s /usr/local/godot/godot /usr/local/bin/godot
  else
    find . -type f -name "Godot_*$(uname -m)" -exec install {} /usr/local/bin/godot \;
  fi
}


# Main
install_requirements
initialize_tempdir
download
install_feature
