#!/usr/bin/env bash

e2e_supported_config_keys() {
  cat <<'EOF'
GITHUB_BROWSER_PROFILE
E2E_GITHUB_AUTO_LOGIN
E2E_GITHUB_AUTO_REMOVE_PROFILE
E2E_GITHUB_FORCE_REMOVE_PROFILE
E2E_MEDIA_AUTO_CLEANUP
E2E_VIDEO_TRIM_START_SECONDS
E2E_VIDEO_AUTO_SCENE_TRIM
E2E_VIDEO_SCENE_THRESHOLD
E2E_VIDEO_SCENE_PREROLL_SECONDS
EOF
}

e2e_is_supported_config_key() {
  local candidate="${1:-}"
  local key=""

  while IFS= read -r key; do
    if [[ "$key" == "$candidate" ]]; then
      return 0
    fi
  done < <(e2e_supported_config_keys)

  return 1
}

e2e_config_dir() {
  if [[ -n "${XDG_CONFIG_HOME:-}" ]]; then
    printf '%s/e2e-pr-assets\n' "$XDG_CONFIG_HOME"
    return
  fi

  printf '%s/.config/e2e-pr-assets\n' "$HOME"
}

e2e_config_file() {
  printf '%s/config\n' "$(e2e_config_dir)"
}

e2e_quote_shell_value() {
  local value="${1-}"
  printf "'%s'" "$(printf '%s' "$value" | sed "s/'/'\\\\''/g")"
}

e2e_format_config_value() {
  local value="${1-}"

  if [[ "$value" =~ ^-?[0-9]+([.][0-9]+)?$ ]]; then
    printf '%s' "$value"
    return
  fi

  printf '%s' "$(e2e_quote_shell_value "$value")"
}

e2e_config_default_value() {
  case "${1:-}" in
    GITHUB_BROWSER_PROFILE) printf '%s' '/tmp/github-upload-profile' ;;
    E2E_GITHUB_AUTO_LOGIN) printf '%s' '1' ;;
    E2E_GITHUB_AUTO_REMOVE_PROFILE) printf '%s' '1' ;;
    E2E_GITHUB_FORCE_REMOVE_PROFILE) printf '%s' '0' ;;
    E2E_MEDIA_AUTO_CLEANUP) printf '%s' '1' ;;
    E2E_VIDEO_TRIM_START_SECONDS) printf '%s' '1' ;;
    E2E_VIDEO_AUTO_SCENE_TRIM) printf '%s' '1' ;;
    E2E_VIDEO_SCENE_THRESHOLD) printf '%s' '0.003' ;;
    E2E_VIDEO_SCENE_PREROLL_SECONDS) printf '%s' '0.05' ;;
    *) return 1 ;;
  esac
}

e2e_config_description() {
  case "${1:-}" in
    GITHUB_BROWSER_PROFILE) printf '%s' 'GitHub browser profile path' ;;
    E2E_GITHUB_AUTO_LOGIN) printf '%s' 'open login flow automatically when needed' ;;
    E2E_GITHUB_AUTO_REMOVE_PROFILE) printf '%s' 'remove temporary browser profile after upload' ;;
    E2E_GITHUB_FORCE_REMOVE_PROFILE) printf '%s' 'allow deleting non-/tmp browser profiles' ;;
    E2E_MEDIA_AUTO_CLEANUP) printf '%s' 'remove /tmp media artifacts after attach' ;;
    E2E_VIDEO_TRIM_START_SECONDS) printf '%s' 'fixed startup trim before conversion' ;;
    E2E_VIDEO_AUTO_SCENE_TRIM) printf '%s' 'adjust trim automatically when first real scene appears later' ;;
    E2E_VIDEO_SCENE_THRESHOLD) printf '%s' 'scene-detect sensitivity for opening trim' ;;
    E2E_VIDEO_SCENE_PREROLL_SECONDS) printf '%s' 'buffer to preserve before first detected scene' ;;
    *) return 1 ;;
  esac
}

e2e_config_value_for_key() {
  local lookup_key="$1"
  local config_file="$2"
  local value=""

  if [[ ! -f "$config_file" ]]; then
    return 1
  fi

  set +e
  value="$(
    CONFIG_FILE="$config_file" CONFIG_KEY="$lookup_key" bash <<'EOF'
set -euo pipefail

# shellcheck source=/dev/null
source "$CONFIG_FILE"

if [[ -z "${!CONFIG_KEY+x}" ]]; then
  exit 1
fi

printf '%s' "${!CONFIG_KEY}"
EOF
  )"
  local exit_code=$?
  set -e

  if [[ "$exit_code" -ne 0 ]]; then
    return 1
  fi

  printf '%s' "$value"
}

e2e_effective_config_value() {
  local key="$1"
  local config_file="${2:-$(e2e_config_file)}"
  local value=""
  local source=""

  if [[ -n "${!key+x}" ]]; then
    value="${!key}"
    source="env"
  elif value="$(e2e_config_value_for_key "$key" "$config_file")"; then
    source="config"
  else
    value="$(e2e_config_default_value "$key")"
    source="default"
  fi

  printf '%s\t%s\n' "$value" "$source"
}

e2e_load_config() {
  local config_file="${1:-$(e2e_config_file)}"
  local keys=()
  local original_is_set=()
  local original_values=()
  local key=""
  local index=0

  if [[ ! -f "$config_file" ]]; then
    return 0
  fi

  while IFS= read -r key; do
    keys+=("$key")
    if [[ -n "${!key+x}" ]]; then
      original_is_set+=("1")
      original_values+=("${!key}")
    else
      original_is_set+=("0")
      original_values+=("")
    fi
  done < <(e2e_supported_config_keys)

  # shellcheck source=/dev/null
  source "$config_file"

  for key in "${keys[@]}"; do
    if [[ "${original_is_set[$index]}" == "1" ]]; then
      printf -v "$key" '%s' "${original_values[$index]}"
    fi
    index=$((index + 1))
  done
}
