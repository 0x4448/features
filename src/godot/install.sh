#!/usr/bin/env bash
set -eu


# Feature Options
VERSION=${VERSION:-"4.2.2"}
DOTNET=${DOTNET:-"false"}
HASH=${HASH:-"none"}


# Script Variables
fileName="godot.zip"


# Functions
install_requirements() {
  apt update
  apt install --yes --no-install-recommends \
    ca-certificates \
    curl \
    unzip
}

initialize_tempdir() {
  tempDir=$(mktemp -d)
  cd "$tempDir" || exit 1
  trap 'rm -rf "$tempDir"' EXIT
}

download() {
  if [ "$DOTNET" == "true" ]; then
    suffix="stable_mono_linux_"
  else
    suffix="stable_linux."
  fi

  url="https://github.com/godotengine/godot/releases/download/$VERSION-stable/Godot_v$VERSION-$suffix$(uname -m).zip"
  curl -fsSL -o "$fileName" "$url"

  if [ "$HASH" != "none" ]; then
    echo "$HASH $fileName" | sha256sum --check
  fi
}

install_feature() {
  unzip "$fileName"

  if [ "$DOTNET" == "true" ]; then
    mv "Godot_v$VERSION-stable_mono_linux_$(uname -m)" /usr/local/godot
    mv "/usr/local/godot/Godot_v$VERSION-stable_mono_linux.$(uname -m)" /usr/local/godot/godot
    chmod +x /usr/local/godot/godot
    ln -s /usr/local/godot/godot /usr/local/bin/godot
  else
    install "Godot_v$VERSION-stable_linux.$(uname -m)" /usr/local/bin/godot
  fi
}


# Main
install_requirements
initialize_tempdir
download
install_feature
