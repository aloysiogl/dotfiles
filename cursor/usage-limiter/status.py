#!/usr/bin/env python3
"""Pretty-print Cursor usage limiter status to the terminal."""

from __future__ import annotations

import json
import sys
from datetime import datetime, timezone
from pathlib import Path

try:
    from datetime import UTC
except ImportError:
    UTC = timezone.utc

STATE_PATH = Path.home() / ".cursor/usage-limiter/state.json"
LOG_PATH = Path.home() / ".cursor/usage-limiter/limiter.log"

# ANSI helpers
RESET  = "\033[0m"
BOLD   = "\033[1m"
DIM    = "\033[2m"
GREEN  = "\033[32m"
YELLOW = "\033[33m"
ORANGE = "\033[38;5;208m"
RED    = "\033[31m"
CYAN   = "\033[36m"


def dollars(cents: int | float) -> str:
    return f"${cents / 100:,.2f}"


def pct_color(pct: float) -> str:
    if pct >= 100:
        return RED
    if pct >= 80:
        return ORANGE
    if pct >= 60:
        return YELLOW
    return GREEN


def bar(pct: float, width: int = 30) -> str:
    filled = min(int(pct / 100 * width), width)
    empty = width - filled
    color = pct_color(pct)
    bar_str = color + "█" * filled + DIM + "░" * empty + RESET
    return f"[{bar_str}]"


def time_ago(iso: str) -> str:
    try:
        dt = datetime.fromisoformat(iso)
        delta = int((datetime.now(UTC) - dt).total_seconds())
        if delta < 60:
            return f"{delta}s ago"
        if delta < 3600:
            return f"{delta // 60}m ago"
        return f"{delta // 3600}h ago"
    except Exception:
        return iso


def alerts_summary(alerts_fired: dict) -> str:
    thresholds = alerts_fired.get("thresholds", {})
    if not thresholds:
        return f"{GREEN}none fired today{RESET}"
    keys = sorted(thresholds.keys(), key=int)
    parts = []
    for k in keys:
        color = pct_color(int(k))
        parts.append(f"{color}{k}%{RESET}")
    return ", ".join(parts)


def last_log_lines(n: int = 3) -> list[str]:
    if not LOG_PATH.exists():
        return []
    lines = LOG_PATH.read_text(encoding="utf-8").splitlines()
    return lines[-n:]


def main() -> None:
    if not STATE_PATH.exists():
        print(f"{YELLOW}No state yet — run poll.py once first.{RESET}")
        sys.exit(1)

    try:
        state = json.loads(STATE_PATH.read_text(encoding="utf-8"))
    except json.JSONDecodeError:
        print(f"{RED}state.json is corrupt.{RESET}")
        sys.exit(1)

    today_used = int(state.get("today_used_cents", 0))
    daily_target = int(state.get("daily_target_cents", 1))
    daily_pct = float(state.get("daily_pct", 0))
    month_used = int(
        state.get("period_used_cents", state.get("month_used_cents", 0))
    )
    cycle_used = int(state.get("cycle_used_cents", 0))
    monthly_target = int(state.get("monthly_target_cents", 0))
    last_poll = state.get("last_poll_at", "")
    day = state.get("day", "")
    month = state.get("month", day[:7] if day else "")
    alerts_fired = state.get("alerts_fired", {})
    error = state.get("error")
    weekdays_only = bool(state.get("weekdays_only", True))
    is_weekend = bool(state.get("is_weekend_today", False))
    weekdays_total = int(state.get("weekdays_total", 1))
    weekdays_elapsed = int(state.get("weekdays_elapsed", 0))
    weekdays_remaining = int(state.get("weekdays_remaining", 0))
    expected_cents = int(state.get("expected_cents", 0))
    cycle_start = state.get("cycle_start", "")
    cycle_end = state.get("cycle_end", "")
    window_start = state.get("budget_window_start", "")
    window_end = state.get("budget_window_end", "")
    period_source = state.get("period_source", "")

    daily_color = pct_color(daily_pct)
    month_pct = (month_used / monthly_target * 100) if monthly_target else 0.0
    month_color = pct_color(month_pct)

    sep = f"{DIM}{'─' * 50}{RESET}"
    scope = "weekdays only" if weekdays_only else "all days"

    print()
    print(
        f"  {BOLD}{CYAN}Cursor Usage Limiter{RESET}  "
        f"{DIM}{month} ({scope})  ·  last poll {time_ago(last_poll)}{RESET}"
    )
    print(f"  {sep}")

    if error:
        print(f"  {RED}{BOLD}⚠  Auth error:{RESET} {RED}{error}{RESET}")
        print(f"  {DIM}Refresh CURSOR_SESSION_TOKEN in ~/.localrc{RESET}")
        print()
        return

    if weekdays_only and is_weekend:
        print(f"  {BOLD}Today{RESET}  {DIM}(weekend — no weekday budget or alerts){RESET}")
        print(f"  {DIM}Spent today: {dollars(today_used)}{RESET}")
        print()
    else:
        divisor_label = (
            f"{weekdays_remaining} weekdays left"
            if weekdays_only
            else "remaining days"
        )
        print(
            f"  {BOLD}Today{RESET}  "
            f"{DIM}(weekday budget: {dollars(daily_target)}  ·  remaining ÷ {divisor_label}){RESET}"
        )
        print(
            f"  {bar(daily_pct)}  "
            f"{daily_color}{BOLD}{daily_pct:.1f}%{RESET}  "
            f"{daily_color}{dollars(today_used)}{RESET} / {dollars(daily_target)}"
        )
        remaining_daily = max(daily_target - today_used, 0)
        print(f"  {DIM}Remaining today: {dollars(remaining_daily)}{RESET}")
        print()

    budget_pct = month_pct
    budget_color = month_color
    delta_cents = month_used - expected_cents
    if delta_cents > 0:
        delta_str = f"{RED}+{dollars(delta_cents)} over pace{RESET}"
    elif delta_cents < 0:
        delta_str = f"{GREEN}{dollars(abs(delta_cents))} under pace{RESET}"
    else:
        delta_str = f"{GREEN}on pace{RESET}"

    pace_label = (
        f"{weekdays_elapsed}/{weekdays_total} weekdays"
        if weekdays_only
        else "budget window"
    )
    window_hint = ""
    if window_start and window_end:
        window_hint = f"  ·  window {window_start}..{window_end}"
    cycle_hint = ""
    if cycle_start and cycle_end:
        cycle_hint = f"  ·  billing cycle {cycle_start}..{cycle_end}"

    print(
        f"  {BOLD}This month{RESET}  "
        f"{DIM}(budget: {dollars(monthly_target)}  ·  {pace_label}{window_hint}){RESET}"
    )
    print(
        f"  {bar(budget_pct)}  "
        f"{budget_color}{BOLD}{budget_pct:.1f}%{RESET}  "
        f"{budget_color}{dollars(month_used)}{RESET} / {dollars(monthly_target)}"
    )
    remaining_month = max(monthly_target - month_used, 0)
    print(
        f"  {DIM}Expected by now ({pace_label}):{RESET}  {dollars(expected_cents)}  "
        f"·  actual: {budget_color}{dollars(month_used)}{RESET}  ·  {delta_str}"
    )
    print(f"  {DIM}Remaining this month: {dollars(remaining_month)}{RESET}")
    print(
        f"  {DIM}Billing cycle total:{RESET}  {dollars(cycle_used)}"
        f"{DIM}{cycle_hint}{RESET}"
    )

    print()

    recent = last_log_lines(1)
    if recent:
        line = recent[0]
        if "T" in line and "+" in line:
            ts, _, rest = line.partition(" ")
            print(f"  {DIM}Last poll:{RESET}  {DIM}{ts}{RESET}  {rest}")
        else:
            print(f"  {DIM}{line}{RESET}")

    print()
    print(f"  {sep}")
    if weekdays_only and is_weekend:
        print(f"  {BOLD}Alerts{RESET}  {DIM}paused on weekends{RESET}")
    else:
        print(f"  {BOLD}Alerts fired today{RESET}  {alerts_summary(alerts_fired)}")

    print()


if __name__ == "__main__":
    main()
