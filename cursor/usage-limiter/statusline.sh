#!/usr/bin/env bash
set -euo pipefail

STATE_FILE="${HOME}/.cursor/usage-limiter/state.json"

if [[ ! -f "$STATE_FILE" ]]; then
  printf '\033[90mCursor usage: waiting for first poll\033[0m'
  exit 0
fi

python3 - "$STATE_FILE" <<'PY'
import json
import sys
from pathlib import Path

state_path = Path(sys.argv[1])
try:
    state = json.loads(state_path.read_text(encoding="utf-8"))
except (OSError, json.JSONDecodeError):
    print("\033[90mCursor usage: unavailable\033[0m")
    raise SystemExit(0)

if state.get("error"):
    print("\033[31mCursor usage: auth error — refresh token\033[0m")
    raise SystemExit(0)

def dollars(cents: int | float) -> str:
    return f"${cents / 100:,.2f}"

today_used = int(state.get("today_used_cents", 0))
daily_target = int(state.get("daily_target_cents", 0))
daily_pct = float(state.get("daily_pct", 0))
month_used = int(state.get("month_used_cents", state.get("cycle_used_cents", 0)))
monthly_target = int(state.get("monthly_target_cents", 0))
weekdays_only = bool(state.get("weekdays_only", True))
is_weekend = bool(state.get("is_weekend_today", False))
month_pct = (month_used / monthly_target * 100) if monthly_target else 0.0

if weekdays_only and is_weekend:
    print(
        f"\033[90mCursor weekend · month {dollars(month_used)}/{dollars(monthly_target)} "
        f"({month_pct:.1f}%)\033[0m"
    )
    raise SystemExit(0)

if daily_pct >= 100:
    color = "\033[31m"
elif daily_pct >= 80:
    color = "\033[38;5;208m"
elif daily_pct >= 60:
    color = "\033[33m"
else:
    color = "\033[32m"

line = (
    f"{color}Cursor {dollars(today_used)}/{dollars(daily_target)} today "
    f"({daily_pct:.1f}%) · {dollars(month_used)}/{dollars(monthly_target)} "
    f"month ({month_pct:.1f}%)\033[0m"
)
print(line)
PY
