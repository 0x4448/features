#!/usr/bin/env bash
set -e

function check_version() {
  actionlint --version | grep -q "1.7.1"
  return $?
}

# shellcheck source=/dev/null
source dev-container-features-test-lib
check "version" check_version
reportResults
