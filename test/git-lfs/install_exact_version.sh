#!/usr/bin/env bash
set -e

function check_version() {
  git lfs version | grep -q "3.5.1"
  return $?
}

# shellcheck source=/dev/null
source dev-container-features-test-lib
check "version" check_version
reportResults
