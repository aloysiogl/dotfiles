#!/usr/bin/env bash

set -euo pipefail

readonly INSTALL_URL="https://github.com/janekbaraniewski/openusage/releases/latest/download/install.sh"
readonly INSTALL_DIR="${HOME}/.local/bin"
readonly OPENUSAGE_BIN="${INSTALL_DIR}/openusage"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

installer="${tmp_dir}/openusage-install.sh"

if command -v curl >/dev/null 2>&1; then
  curl -fsSL "$INSTALL_URL" -o "$installer"
elif command -v wget >/dev/null 2>&1; then
  wget -qO "$installer" "$INSTALL_URL"
else
  echo "  OpenUsage requires curl or wget. Skipping."
  exit 0
fi

echo "  Installing the latest OpenUsage release..."
bash "$installer" --install-dir "$INSTALL_DIR"

# The daemon is local-only and persists usage events in
# ~/.local/state/openusage/telemetry.db.
if [[ "${OPENUSAGE_INSTALL_DAEMON:-1}" == "1" ]]; then
  if ! "$OPENUSAGE_BIN" telemetry daemon install; then
    echo "  OpenUsage daemon installation failed; run it manually when a user service manager is available."
  fi
fi

# Cursor is detected from its local state database and does not have an
# OpenUsage hook integration. Claude Code and Codex hooks provide live events
# while preserving their existing configuration entries.
if command -v claude >/dev/null 2>&1; then
  "$OPENUSAGE_BIN" integrations install claude_code
fi

if command -v codex >/dev/null 2>&1; then
  "$OPENUSAGE_BIN" integrations install codex
fi

echo "  OpenUsage installed. Run: openusage"
