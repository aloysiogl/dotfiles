#!/usr/bin/env bash
# Clear today's alert flags and run one poll (fires notifications if thresholds are met).
set -euo pipefail

POLL="${HOME}/.cursor/usage-limiter/poll.py"
STATUS="${HOME}/.cursor/usage-limiter/status.py"

python3 - <<'PY'
import json
from pathlib import Path

state_path = Path.home() / ".cursor/usage-limiter/state.json"
if not state_path.exists():
    raise SystemExit("No state.json yet — run poll.py once first.")

state = json.loads(state_path.read_text())
state["alerts_fired"] = {"thresholds": {}}
state_path.write_text(json.dumps(state, indent=2) + "\n")
print("\033[2mAlert flags cleared.\033[0m")
PY

python3 "$POLL"
python3 "$STATUS"
