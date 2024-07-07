#!/usr/bin/env bash
set -e

function check_version() {
  shellcheck --version | grep -q "0.10.0"
  return $?
}

# shellcheck source=/dev/null
source dev-container-features-test-lib
check "version" check_version
reportResults
