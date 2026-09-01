#!/usr/bin/env bash

set -euo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
readonly REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd -P)"
readonly PACKAGES_DIR="${REPO_ROOT}/packages"
readonly TARGET_HOME="${HOME:?HOME must be set}"
readonly STATE_ROOT="${XDG_STATE_HOME:-${TARGET_HOME}/.local/state}"
readonly BACKUP_ROOT="${STATE_ROOT}/dotfiles/backups/$(date '+%Y%m%d-%H%M%S')"
readonly -a ALL_PACKAGES=(nvim tmux hunk ghostty nushell zsh)

usage() {
  cat <<'EOF'
Usage: scripts/install.sh [package ...]

Install all dotfile packages, or only the named packages:
  nvim tmux hunk ghostty nushell zsh
EOF
}

is_known_package() {
  local candidate="$1"
  local package

  for package in "${ALL_PACKAGES[@]}"; do
    if [[ "${candidate}" == "${package}" ]]; then
      return 0
    fi
  done

  return 1
}

canonical_existing_path() {
  local path="$1"
  local directory
  local basename

  directory="$(dirname -- "${path}")"
  basename="$(basename -- "${path}")"
  printf '%s/%s\n' "$(cd -P -- "${directory}" && pwd -P)" "${basename}"
}

link_points_to_source() {
  local destination="$1"
  local source="$2"
  local link_target

  [[ -L "${destination}" ]] || return 1
  link_target="$(readlink -- "${destination}")"

  if [[ "${link_target}" != /* ]]; then
    link_target="$(dirname -- "${destination}")/${link_target}"
  fi

  [[ -e "${link_target}" ]] || return 1
  [[ "$(canonical_existing_path "${link_target}")" == "$(canonical_existing_path "${source}")" ]]
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if ! command -v stow >/dev/null 2>&1; then
  printf 'GNU Stow is required. Install it with: brew install stow\n' >&2
  exit 1
fi

if (( $# == 0 )); then
  packages=("${ALL_PACKAGES[@]}")
else
  packages=("$@")
fi

for package in "${packages[@]}"; do
  if ! is_known_package "${package}"; then
    printf 'Unknown package: %s\n' "${package}" >&2
    usage >&2
    exit 2
  fi
done

backup_created=false
for package in "${packages[@]}"; do
  package_root="${PACKAGES_DIR}/${package}"

  while IFS= read -r -d '' source; do
    relative_path="${source#"${package_root}/"}"
    destination="${TARGET_HOME}/${relative_path}"

    if link_points_to_source "${destination}" "${source}"; then
      continue
    fi

    if [[ -e "${destination}" || -L "${destination}" ]]; then
      backup_destination="${BACKUP_ROOT}/${relative_path}"
      mkdir -p -- "$(dirname -- "${backup_destination}")"
      mv -- "${destination}" "${backup_destination}"
      printf 'Backed up %s to %s\n' "${destination}" "${backup_destination}"
      backup_created=true
    fi
  done < <(find "${package_root}" \( -type f -o -type l \) -print0)
done

stow_options=(
  --dir="${PACKAGES_DIR}"
  --target="${TARGET_HOME}"
  --no-folding
  --restow
)

stow --simulate --verbose=1 "${stow_options[@]}" "${packages[@]}"
stow "${stow_options[@]}" "${packages[@]}"

if [[ "${backup_created}" == true ]]; then
  printf 'Backups are available at %s\n' "${BACKUP_ROOT}"
fi

printf 'Installed packages: %s\n' "${packages[*]}"
