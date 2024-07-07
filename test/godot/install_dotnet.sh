#!/usr/bin/env bash
set -e

function check_version() {
  godot --version | grep -q "4.2.2"
  return $?
}

# shellcheck source=/dev/null
source dev-container-features-test-lib
check "version" check_version
check "godot-sharp" test -d /usr/local/godot/GodotSharp
reportResults
