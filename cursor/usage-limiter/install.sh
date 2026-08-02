#!/bin/sh
#
# Install Cursor usage limiter: symlink runtime dir, LaunchAgent, CLI statusline.

set -e

LIMITER_DIR="$(cd "$(dirname "$0")" && pwd)"
CURSOR_DIR="$(dirname "$LIMITER_DIR")"
RUNTIME_DIR="${HOME}/.cursor/usage-limiter"
LAUNCH_AGENT="${HOME}/Library/LaunchAgents/com.cursor.usage-limiter.plist"
CLI_CONFIG="${HOME}/.cursor/cli-config.json"

if [ "$(uname)" != "Darwin" ]; then
  echo "  usage-limiter: macOS only (LaunchAgent + Swift alerts). Skipping."
  exit 0
fi

mkdir -p "${RUNTIME_DIR}" "${HOME}/Library/LaunchAgents"

link_file() {
  src="$1"
  dest="$2"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    backup="${dest}.bak.$(date +%Y%m%d%H%M%S)"
    mv "$dest" "$backup"
    echo "  Backed up existing $(basename "$dest") → $(basename "$backup")"
  fi
  ln -sf "$src" "$dest"
}

for name in alert.swift calendar_budget.py config.json poll.py run-poll.sh set-budget.sh status.py statusline.sh trigger-alert.sh usage_events.py; do
  link_file "${LIMITER_DIR}/${name}" "${RUNTIME_DIR}/${name}"
done

chmod +x "${RUNTIME_DIR}/run-poll.sh" "${RUNTIME_DIR}/set-budget.sh" "${RUNTIME_DIR}/statusline.sh" "${RUNTIME_DIR}/trigger-alert.sh"

POLL_INTERVAL="$(python3 - "${LIMITER_DIR}/config.json" <<'PY'
import json
import sys
from pathlib import Path

config = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
print(int(config.get("poll_interval_seconds", 600)))
PY
)"

sed \
  -e "s|__RUN_POLL__|${RUNTIME_DIR}/run-poll.sh|g" \
  -e "s|__LOG_PATH__|${RUNTIME_DIR}/limiter.log|g" \
  -e "s|__WORKDIR__|${RUNTIME_DIR}|g" \
  -e "s|__POLL_INTERVAL__|${POLL_INTERVAL}|g" \
  "${LIMITER_DIR}/com.cursor.usage-limiter.plist.template" > "$LAUNCH_AGENT"

launchctl bootout "gui/$(id -u)/com.cursor.usage-limiter" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$LAUNCH_AGENT"
launchctl kickstart -k "gui/$(id -u)/com.cursor.usage-limiter" 2>/dev/null || true
echo "  LaunchAgent installed and started (polls every ${POLL_INTERVAL}s)."

# Merge statusLine into Cursor CLI config without clobbering other settings.
mkdir -p "$(dirname "$CLI_CONFIG")"
python3 - "$CLI_CONFIG" "${RUNTIME_DIR}/statusline.sh" <<'PY'
import json
import sys
from pathlib import Path

config_path = Path(sys.argv[1])
statusline_cmd = sys.argv[2]

data = {}
if config_path.exists():
    try:
        data = json.loads(config_path.read_text(encoding="utf-8"))
    except json.JSONDecodeError:
        data = {}

data["statusLine"] = {
    "type": "command",
    "command": statusline_cmd,
    "padding": 2,
    "updateIntervalMs": 5000,
    "timeoutMs": 2000,
}
config_path.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")
PY
echo "  Cursor CLI statusLine → ${RUNTIME_DIR}/statusline.sh"

echo "  Usage limiter ready. Run: python3 ${RUNTIME_DIR}/status.py"
