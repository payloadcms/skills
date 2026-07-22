#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/../../.." && pwd)"
BIN_DIR="${REPO_ROOT}/tools/e2e-pr-assets/bin"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

export HOME="${TMP_DIR}/home"
export XDG_CONFIG_HOME="${TMP_DIR}/config"

mkdir -p "$HOME" "$XDG_CONFIG_HOME"

CONFIG_FILE="${XDG_CONFIG_HOME}/e2e-pr-assets/config"

assert_contains() {
  local haystack="$1"
  local needle="$2"

  if [[ "$haystack" != *"$needle"* ]]; then
    echo "Expected output to contain: $needle" >&2
    exit 1
  fi
}

assert_not_contains() {
  local haystack="$1"
  local needle="$2"

  if [[ "$haystack" == *"$needle"* ]]; then
    echo "Expected output to not contain: $needle" >&2
    exit 1
  fi
}

show_output="$("${BIN_DIR}/e2e-pr-assets" --show-config)"
assert_contains "$show_output" "${CONFIG_FILE}"
assert_contains "$show_output" '# Configure with `e2e-pr-assets --configure KEY VALUE`'
assert_contains "$show_output" "# or manually update /Users/jflesch/.config/e2e-pr-assets/config"
assert_contains "$show_output" "# Configurable keys:"
assert_contains "$show_output" "# GITHUB_BROWSER_PROFILE"
assert_contains "$show_output" "# - Description: GitHub browser profile path"
assert_contains "$show_output" "# - Default: '/tmp/github-upload-profile'"
assert_contains "$show_output" "# E2E_MEDIA_AUTO_CLEANUP"
assert_contains "$show_output" "# Configured keys:"
assert_contains "$show_output" "# (none)"

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Expected --show-config to create a config file" >&2
  exit 1
fi

file_contents="$(cat "$CONFIG_FILE")"
assert_contains "$file_contents" '# Configure with `e2e-pr-assets --configure KEY VALUE`'
assert_contains "$file_contents" "# Configurable keys:"
assert_contains "$file_contents" "# Configured keys:"
assert_contains "$file_contents" "# (none)"
assert_not_contains "$file_contents" "GITHUB_BROWSER_PROFILE='/tmp/github-upload-profile'"

cat >"$CONFIG_FILE" <<'EOF'
# e2e-pr-assets configuration
# Environment variables override values in this file.
# Update values with `e2e-pr-assets --configure KEY VALUE`.
#
# Common keys:
E2E_GITHUB_AUTO_REMOVE_PROFILE=0
EOF

show_output="$("${BIN_DIR}/e2e-pr-assets" --show-config)"
assert_contains "$show_output" '# Configure with `e2e-pr-assets --configure KEY VALUE`'
assert_contains "$show_output" "E2E_GITHUB_AUTO_REMOVE_PROFILE=0"

file_contents="$(cat "$CONFIG_FILE")"
assert_contains "$file_contents" '# Configure with `e2e-pr-assets --configure KEY VALUE`'
assert_contains "$file_contents" "# Configured keys:"
assert_not_contains "$file_contents" "# Common keys:"
assert_contains "$file_contents" "E2E_GITHUB_AUTO_REMOVE_PROFILE=0"

"${BIN_DIR}/e2e-pr-assets" --configure E2E_GITHUB_AUTO_REMOVE_PROFILE 0 >/dev/null
"${BIN_DIR}/e2e-pr-assets" --configure GITHUB_BROWSER_PROFILE "${HOME}/github-profile" >/dev/null

file_contents="$(cat "$CONFIG_FILE")"
assert_contains "$file_contents" "# Configurable keys:"
assert_contains "$file_contents" "# Configured keys:"
assert_contains "$file_contents" "E2E_GITHUB_AUTO_REMOVE_PROFILE=0"
assert_contains "$file_contents" "GITHUB_BROWSER_PROFILE='${HOME}/github-profile'"
assert_not_contains "$file_contents" "E2E_MEDIA_AUTO_CLEANUP=1"
assert_not_contains "$file_contents" "# (none)"

show_output="$("${BIN_DIR}/e2e-pr-assets" --show-config)"
assert_contains "$show_output" "E2E_GITHUB_AUTO_REMOVE_PROFILE=0"
assert_contains "$show_output" "GITHUB_BROWSER_PROFILE='${HOME}/github-profile'"

# shellcheck source=/dev/null
source "${REPO_ROOT}/tools/e2e-pr-assets/lib/config.sh"
e2e_load_config

if [[ "${E2E_GITHUB_AUTO_REMOVE_PROFILE}" != "0" ]]; then
  echo "Expected config loader to read E2E_GITHUB_AUTO_REMOVE_PROFILE=0" >&2
  exit 1
fi

if [[ "${GITHUB_BROWSER_PROFILE}" != "${HOME}/github-profile" ]]; then
  echo "Expected config loader to read GITHUB_BROWSER_PROFILE from the config file" >&2
  exit 1
fi

export E2E_GITHUB_AUTO_REMOVE_PROFILE=1
e2e_load_config

if [[ "${E2E_GITHUB_AUTO_REMOVE_PROFILE}" != "1" ]]; then
  echo "Expected explicit env vars to override config file values" >&2
  exit 1
fi

"${BIN_DIR}/e2e-pr-assets" --unset GITHUB_BROWSER_PROFILE >/dev/null
show_output="$("${BIN_DIR}/e2e-pr-assets" --show-config)"
assert_not_contains "$show_output" "GITHUB_BROWSER_PROFILE='${HOME}/github-profile'"

file_contents="$(cat "$CONFIG_FILE")"
assert_not_contains "$file_contents" "GITHUB_BROWSER_PROFILE="
assert_contains "$file_contents" "E2E_GITHUB_AUTO_REMOVE_PROFILE=0"
