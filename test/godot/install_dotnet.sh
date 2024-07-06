#!/usr/bin/env bash
set -e

# shellcheck source=/dev/null
source dev-container-features-test-lib
check "version" godot --version
check "godot-sharp" test -d /usr/local/godot/GodotSharp
reportResults
