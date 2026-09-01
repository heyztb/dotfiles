#!/usr/bin/env bash

set -euo pipefail

readonly TPM_DIR="${HOME:?HOME must be set}/.tmux/plugins/tpm"

if [[ -d "${TPM_DIR}/.git" ]]; then
  printf 'TPM is already installed at %s\n' "${TPM_DIR}"
  exit 0
fi

if [[ -e "${TPM_DIR}" ]]; then
  printf 'Refusing to replace existing non-Git path: %s\n' "${TPM_DIR}" >&2
  exit 1
fi

mkdir -p -- "$(dirname -- "${TPM_DIR}")"
git clone https://github.com/tmux-plugins/tpm.git "${TPM_DIR}"
printf 'Installed TPM at %s\n' "${TPM_DIR}"
