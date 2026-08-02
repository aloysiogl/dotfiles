#!/usr/bin/env python3
"""Poll Cursor usage-summary and fire macOS notifications at daily budget thresholds."""

from __future__ import annotations

import json
import subprocess
import sys
import urllib.error
import urllib.request
from datetime import datetime, timezone
from pathlib import Path

from calendar_budget import (
    budget_window,
    compute_budget_targets,
    local_today,
    month_bounds,
    parse_cycle_dates,
)
from usage_events import resolve_month_used_cents

RUNTIME_DIR = Path.home() / ".cursor" / "usage-limiter"
CONFIG_PATH = RUNTIME_DIR / "config.json"
STATE_PATH = RUNTIME_DIR / "state.json"
LOCALRC_PATH = Path.home() / ".localrc"
LOG_PATH = RUNTIME_DIR / "limiter.log"
ALERT_SCRIPT = RUNTIME_DIR / "alert.swift"

API_URL = "https://cursor.com/api/usage-summary"
REQUEST_TIMEOUT_SECONDS = 15

try:
    from datetime import UTC
except ImportError:
    UTC = timezone.utc


def log(message: str) -> None:
    timestamp = datetime.now(UTC).isoformat()
    line = f"{timestamp} {message}\n"
    LOG_PATH.parent.mkdir(parents=True, exist_ok=True)
    with LOG_PATH.open("a", encoding="utf-8") as handle:
        handle.write(line)


def load_config() -> dict:
    with CONFIG_PATH.open(encoding="utf-8") as handle:
        return json.load(handle)


def load_session_token() -> str | None:
    import os

    token = os.environ.get("CURSOR_SESSION_TOKEN", "").strip()
    if token:
        return token

    if not LOCALRC_PATH.exists():
        return None
    for line in LOCALRC_PATH.read_text(encoding="utf-8").splitlines():
        stripped = line.strip()
        if not stripped or stripped.startswith("#"):
            continue
        if stripped.startswith("export "):
            stripped = stripped.removeprefix("export ").lstrip()
        if stripped.startswith("CURSOR_SESSION_TOKEN="):
            token = stripped.split("=", 1)[1].strip().strip('"').strip("'")
            return token or None
    return None


def resolve_team_id(config: dict) -> int:
    import os

    env_team_id = os.environ.get("CURSOR_TEAM_ID", "").strip()
    if env_team_id:
        return int(env_team_id)
    return int(config["team_id"])


def load_state() -> dict:
    if not STATE_PATH.exists():
        return {}
    try:
        with STATE_PATH.open(encoding="utf-8") as handle:
            return json.load(handle)
    except (json.JSONDecodeError, OSError):
        return {}


def save_state(state: dict) -> None:
    STATE_PATH.parent.mkdir(parents=True, exist_ok=True)
    with STATE_PATH.open("w", encoding="utf-8") as handle:
        json.dump(state, handle, indent=2)
        handle.write("\n")


def format_dollars(cents: int | float) -> str:
    return f"${cents / 100:,.2f}"


def format_pct(value: float) -> str:
    return f"{value:.1f}%"


def local_today_key() -> str:
    return local_today().isoformat()


def parse_usage_summary(payload: dict) -> tuple[int, int]:
    individual = payload.get("individualUsage") or {}
    overall = individual.get("overall")
    if isinstance(overall, dict) and overall.get("enabled"):
        return int(overall.get("used", 0)), int(overall.get("limit", 0))

    on_demand = individual.get("onDemand")
    if isinstance(on_demand, dict) and on_demand.get("enabled"):
        return int(on_demand.get("used", 0)), int(on_demand.get("limit") or 0)

    plan = individual.get("plan")
    if isinstance(plan, dict) and plan.get("enabled"):
        return int(plan.get("used", 0)), int(plan.get("limit", 0))

    raise ValueError(f"Unsupported usage-summary shape: {json.dumps(individual)[:300]}")


def cycle_days(payload: dict) -> int:
    start = datetime.fromisoformat(payload["billingCycleStart"].replace("Z", "+00:00"))
    end = datetime.fromisoformat(payload["billingCycleEnd"].replace("Z", "+00:00"))
    days = (end - start).days
    return max(days, 1)


def fetch_usage_summary(team_id: int, session_token: str) -> dict:
    url = f"{API_URL}?teamId={team_id}"
    request = urllib.request.Request(
        url,
        headers={
            "Accept": "*/*",
            "Cookie": f"WorkosCursorSessionToken={session_token}",
            "User-Agent": (
                "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) "
                "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36"
            ),
        },
        method="GET",
    )
    with urllib.request.urlopen(request, timeout=REQUEST_TIMEOUT_SECONDS) as response:
        return json.load(response)


def notify_swift_alert(
    threshold: int,
    today_used_cents: int,
    daily_target_cents: int,
    daily_pct: float,
    cycle_used_cents: int,
    cycle_limit_cents: int,
    cycle_pct: float,
) -> None:
    """Launch alert.swift in the background; returns immediately."""
    subprocess.Popen(
        [
            "swift",
            str(ALERT_SCRIPT),
            str(threshold),
            str(today_used_cents),
            str(daily_target_cents),
            f"{daily_pct:.1f}",
            str(cycle_used_cents),
            str(cycle_limit_cents),
            f"{cycle_pct:.1f}",
        ],
        close_fds=True,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )


def notify_macos(title: str, message: str, sound: str | None = None) -> None:
    """Fallback plain osascript alert — used only for auth failure notices."""
    escaped_title = title.replace("\\", "\\\\").replace('"', '\\"')
    escaped_message = message.replace("\\", "\\\\").replace('"', '\\"')
    script = (
        f'display alert "{escaped_title}" message "{escaped_message}" '
        f'as warning buttons {{"OK"}}'
    )
    subprocess.Popen(["osascript", "-e", script], close_fds=True)


def maybe_notify_auth_failure(state: dict) -> None:
    today = local_today_key()
    alerts = state.setdefault("alerts_fired", {})
    if alerts.get("auth_failure") == today:
        return
    notify_macos(
        "Cursor usage limiter — session expired",
        "Could not fetch usage. Refresh CURSOR_SESSION_TOKEN in ~/.localrc",
        "Basso",
    )
    alerts["auth_failure"] = today
    save_state(state)



def maybe_fire_threshold_alerts(
    state: dict,
    daily_pct: float,
    today_used_cents: int,
    daily_target_cents: int,
    cycle_used_cents: int,
    cycle_limit_cents: int,
    cycle_pct: float,
    thresholds: list[int],
    *,
    alerts_enabled: bool,
) -> None:
    if not alerts_enabled:
        return
    today = local_today_key()
    alerts = state.setdefault("alerts_fired", {})
    threshold_alerts = alerts.setdefault("thresholds", {})

    for threshold in sorted(thresholds):
        if daily_pct < threshold:
            continue
        if threshold_alerts.get(str(threshold)) == today:
            continue

        notify_swift_alert(
            threshold,
            today_used_cents,
            daily_target_cents,
            daily_pct,
            cycle_used_cents,
            cycle_limit_cents,
            cycle_pct,
        )
        threshold_alerts[str(threshold)] = today
        log(f"Alert fired at {threshold}% (daily {format_pct(daily_pct)})")


def main() -> int:
    config = load_config()
    session_token = load_session_token()
    state = load_state()

    if not session_token:
        log("Missing CURSOR_SESSION_TOKEN in ~/.localrc")
        return 1

    team_id = resolve_team_id(config)
    monthly_target_cents = int(config["monthly_target_cents"])
    weekdays_only = bool(config.get("weekdays_only", True))
    thresholds = [int(value) for value in config.get("alert_thresholds", [60, 80, 100])]

    try:
        payload = fetch_usage_summary(team_id, session_token)
    except urllib.error.HTTPError as error:
        log(f"HTTP error {error.code}: {error.reason}")
        maybe_notify_auth_failure(state)
        return 1
    except urllib.error.URLError as error:
        log(f"Network error: {error.reason}")
        return 1
    except Exception as error:  # noqa: BLE001
        log(f"Unexpected fetch error: {error}")
        return 1

    if payload.get("error") == "not_authenticated":
        log("Authentication failed: not_authenticated")
        maybe_notify_auth_failure(state)
        return 1

    try:
        cycle_used_cents, cycle_limit_cents = parse_usage_summary(payload)
    except ValueError as error:
        log(str(error))
        return 1

    days_in_cycle = cycle_days(payload)
    today_date = local_today()
    today = today_date.isoformat()
    month_start, month_end = month_bounds(today_date)
    cycle_start, cycle_end = parse_cycle_dates(payload)
    window_start, window_end = budget_window(
        month_start, month_end, cycle_start, cycle_end
    )

    period_used_cents, period_source = resolve_month_used_cents(
        cycle_used_cents=cycle_used_cents,
        cycle_start=cycle_start,
        month_start=month_start,
        today=today_date,
        session_token=session_token,
        team_id=team_id,
    )

    if state.get("day") != today:
        state = {
            "day": today,
            "baseline_used_cents": cycle_used_cents,
            "alerts_fired": {},
        }

    budget = compute_budget_targets(
        monthly_target_cents=monthly_target_cents,
        period_used_cents=period_used_cents,
        today=today_date,
        weekdays_only=weekdays_only,
        window_start=window_start,
        window_end=window_end,
    )

    daily_target_cents = int(budget["daily_target_cents"])
    is_weekend_today = bool(budget.get("is_weekend_today", False))
    alerts_enabled = not (weekdays_only and is_weekend_today)

    baseline_used_cents = int(state.get("baseline_used_cents", cycle_used_cents))
    today_used_cents = max(cycle_used_cents - baseline_used_cents, 0)
    if daily_target_cents > 0:
        daily_pct = (today_used_cents / daily_target_cents) * 100
    else:
        daily_pct = 0.0
    cycle_pct = (cycle_used_cents / cycle_limit_cents) * 100 if cycle_limit_cents else 0.0

    month_key = today[:7]

    state.update(
        {
            "day": today,
            "month": month_key,
            "baseline_used_cents": baseline_used_cents,
            "last_poll_at": datetime.now(UTC).isoformat(),
            "billing_cycle_start": payload.get("billingCycleStart"),
            "billing_cycle_end": payload.get("billingCycleEnd"),
            "cycle_start": cycle_start.isoformat(),
            "cycle_end": cycle_end.isoformat(),
            "cycle_days": days_in_cycle,
            "cycle_used_cents": cycle_used_cents,
            "cycle_limit_cents": cycle_limit_cents,
            "cycle_pct": round(cycle_pct, 2),
            "month_start": month_start.isoformat(),
            "month_end": month_end.isoformat(),
            "budget_window_start": window_start.isoformat(),
            "budget_window_end": window_end.isoformat(),
            "period_used_cents": period_used_cents,
            "period_source": period_source,
            "month_used_cents": period_used_cents,
            "weekdays_only": weekdays_only,
            "weekdays_total": int(budget["weekdays_total"]),
            "weekdays_elapsed": int(budget["weekdays_elapsed"]),
            "weekdays_remaining": int(budget["weekdays_remaining"]),
            "is_weekend_today": is_weekend_today,
            "expected_cents": int(budget["expected_cents"]),
            "monthly_target_cents": monthly_target_cents,
            "daily_target_cents": daily_target_cents,
            "today_used_cents": today_used_cents,
            "daily_pct": round(daily_pct, 2),
            "error": None,
        }
    )
    save_state(state)

    maybe_fire_threshold_alerts(
        state,
        daily_pct,
        today_used_cents,
        daily_target_cents,
        cycle_used_cents,
        cycle_limit_cents,
        cycle_pct,
        thresholds,
        alerts_enabled=alerts_enabled,
    )
    save_state(state)

    log(
        "Poll ok: "
        f"today {format_dollars(today_used_cents)}/{format_dollars(daily_target_cents)} "
        f"({format_pct(daily_pct)}), "
        f"month {format_dollars(period_used_cents)}/{format_dollars(monthly_target_cents)} "
        f"({int(budget['weekdays_elapsed'])}/{int(budget['weekdays_total'])} weekdays, "
        f"cycle {format_dollars(cycle_used_cents)}, source={period_source})"
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
