#!/usr/bin/env bash
set -e

# shellcheck source=/dev/null
source dev-container-features-test-lib
check "version" hadolint --version
reportResults
