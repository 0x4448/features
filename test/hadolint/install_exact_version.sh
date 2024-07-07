#!/usr/bin/env bash
set -e

function check_version() {
  hadolint --version | grep -q "2.12.0"
  return $?
}

# shellcheck source=/dev/null
source dev-container-features-test-lib
check "version" check_version
reportResults
