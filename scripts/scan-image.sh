#!/usr/bin/env bash
set -euo pipefail

image_ref="${1:-access-portal:local}"

if ! command -v trivy >/dev/null 2>&1; then
  printf 'Trivy is required. Install it using the official guide: https://trivy.dev/latest/getting-started/installation/\n' >&2
  exit 127
fi

trivy image \
  --scanners vuln \
  --severity HIGH,CRITICAL \
  --exit-code 1 \
  --format table \
  "$image_ref"
