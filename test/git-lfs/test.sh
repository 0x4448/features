#!/usr/bin/env bash
set -e

# shellcheck source=/dev/null
source dev-container-features-test-lib
check "version" git lfs version
reportResults
