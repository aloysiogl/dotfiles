#!/usr/bin/env bash
# Set monthly budget in dollars.
# Usage: set-budget.sh <dollars>
# Example: set-budget.sh 300
set -euo pipefail

CONFIG="${HOME}/.cursor/usage-limiter/config.json"

if [[ $# -ne 1 ]]; then
  echo "Usage: set-budget.sh <monthly_dollars>"
  echo "Example: set-budget.sh 300   → sets \$300/month"
  exit 1
fi

DOLLARS="$1"

# Validate: must be a positive integer or decimal
if ! [[ "$DOLLARS" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
  echo "Error: '$DOLLARS' is not a valid dollar amount."
  exit 1
fi

python3 - "$CONFIG" "$DOLLARS" <<'PY'
import json
import sys
from pathlib import Path

config_path = Path(sys.argv[1])
dollars = float(sys.argv[2])
cents = int(round(dollars * 100))

config = json.loads(config_path.read_text())
old_cents = config.get("monthly_target_cents", 0)
config["monthly_target_cents"] = cents
config_path.write_text(json.dumps(config, indent=2) + "\n")

cycle_days = 30  # approximate; actual is read from API at poll time
daily = cents / cycle_days

RESET  = "\033[0m"
BOLD   = "\033[1m"
GREEN  = "\033[32m"
DIM    = "\033[2m"

print(f"\n  {GREEN}{BOLD}Budget updated{RESET}")
print(f"  {DIM}was:{RESET}  ${old_cents/100:,.2f}/month")
print(f"  {BOLD}now:{RESET}  ${cents/100:,.2f}/month  →  ~${daily/100:,.2f}/day")
print(f"\n  {DIM}Run poll.py or wait for the next poll tick to take effect.{RESET}\n")
PY
