#!/usr/bin/env bash
set -eu

VERSION=${VERSION:-"stable"}
HASH=${HASH:-"none"}

# Package requirements
apt update
apt install --yes --no-install-recommends \
  ca-certificates \
  curl \
  xz-utils

tempDir=$(mktemp -d)
pushd "$tempDir" > /dev/null

url="https://github.com/koalaman/shellcheck/releases/download/$VERSION/shellcheck-$VERSION.linux.$(uname -m).tar.xz"
output="shellcheck.tar.xz"
curl -fsSL -o "$output" "$url"

if [ "$HASH" != "none" ]; then
  echo "$HASH $output" | sha256sum --check
fi

tar xf "$output"
install "shellcheck-$VERSION/shellcheck" /usr/local/bin/shellcheck

popd > /dev/null
rm -rf "$tempDir"
