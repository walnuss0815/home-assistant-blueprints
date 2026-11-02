#!/usr/bin/env bash
# Usage: scripts/check.sh [lint|config|all]
# Needs a container engine only. Set CONTAINER_ENGINE=podman to use podman.
set -euo pipefail

# renovate: datasource=docker depName=ghcr.io/home-assistant/home-assistant
HA_VERSION="${HA_VERSION:-2026.10.4}"
# renovate: datasource=docker depName=pipelinecomponents/yamllint
YAMLLINT_VERSION="${YAMLLINT_VERSION:-0.35.27}"

ENGINE="${CONTAINER_ENGINE:-docker}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

lint() {
  "$ENGINE" run --rm -v "$ROOT:/code:ro" "pipelinecomponents/yamllint:$YAMLLINT_VERSION" yamllint .
}

# check_config exits 0 even when a blueprint is broken: errors are only logged, so grep the log.
config() {
  local tmp cid log
  tmp="$(mktemp -d)"
  log="$tmp/check.log"
  trap '[ -z "${cid:-}" ] || "$ENGINE" rm -f "$cid" >/dev/null; rm -rf "$tmp"' RETURN

  # Copy files into the container instead of bind-mounting: avoids root-owned files on the host.
  # Blueprint paths in the test config are "repo/<name>.yaml".
  for d in automation script; do
    mkdir -p "$tmp/tree/blueprints/$d/repo"
    cp -r "$ROOT/blueprints/$d/." "$tmp/tree/blueprints/$d/repo/"
  done
  cp "$ROOT/tests/config/configuration.yaml" "$tmp/tree/"

  echo "Home Assistant: $HA_VERSION"
  cid="$("$ENGINE" create --entrypoint "" "ghcr.io/home-assistant/home-assistant:$HA_VERSION" \
    python -m homeassistant --config /config --script check_config)"
  tar -C "$tmp/tree" --owner=0 --group=0 -c . | "$ENGINE" cp - "$cid:/config"
  "$ENGINE" start -a "$cid" 2>&1 | tee "$log"

  if grep -qE '^(ERROR|CRITICAL)' "$log"; then
    echo "check_config reported errors" >&2
    return 1
  fi
}

case "${1:-all}" in
  lint) lint ;;
  config) config ;;
  all) lint && config ;;
  *) echo "Usage: $0 [lint|config|all]" >&2; exit 2 ;;
esac
