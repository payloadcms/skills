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
assert_contains "$show_output" "# Config file: ${CONFIG_FILE}"
assert_contains "$show_output" "GITHUB_BROWSER_PROFILE='/tmp/github-upload-profile'"
assert_contains "$show_output" "# default;"

if [[ -f "$CONFIG_FILE" ]]; then
  echo "Expected --show-config to not create a config file" >&2
  exit 1
fi

"${BIN_DIR}/e2e-pr-assets" --configure E2E_GITHUB_AUTO_REMOVE_PROFILE 0 >/dev/null
"${BIN_DIR}/e2e-pr-assets" --configure GITHUB_BROWSER_PROFILE "${HOME}/github-profile" >/dev/null

file_contents="$(cat "$CONFIG_FILE")"
assert_contains "$file_contents" "E2E_GITHUB_AUTO_REMOVE_PROFILE=0"
assert_contains "$file_contents" "GITHUB_BROWSER_PROFILE='${HOME}/github-profile'"
assert_not_contains "$file_contents" "E2E_MEDIA_AUTO_CLEANUP="
assert_not_contains "$file_contents" "Environment variables override values in this file."

show_output="$("${BIN_DIR}/e2e-pr-assets" --show-config)"
assert_contains "$show_output" "E2E_GITHUB_AUTO_REMOVE_PROFILE=0"
assert_contains "$show_output" "GITHUB_BROWSER_PROFILE='${HOME}/github-profile'"
assert_contains "$show_output" "# config;"

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
show_output="$("${BIN_DIR}/e2e-pr-assets" --show-config)"
assert_contains "$show_output" "E2E_GITHUB_AUTO_REMOVE_PROFILE=1"
assert_contains "$show_output" "# env;"

e2e_load_config

if [[ "${E2E_GITHUB_AUTO_REMOVE_PROFILE}" != "1" ]]; then
  echo "Expected explicit env vars to override config file values" >&2
  exit 1
fi

"${BIN_DIR}/e2e-pr-assets" --unset GITHUB_BROWSER_PROFILE >/dev/null
show_output="$("${BIN_DIR}/e2e-pr-assets" --show-config)"
assert_contains "$show_output" "GITHUB_BROWSER_PROFILE='/tmp/github-upload-profile'"
assert_contains "$show_output" "# default;"

file_contents="$(cat "$CONFIG_FILE")"
assert_not_contains "$file_contents" "GITHUB_BROWSER_PROFILE="
