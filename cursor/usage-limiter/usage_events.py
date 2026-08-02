"""Fetch Cursor usage events and sum charged spend."""

from __future__ import annotations

import json
import urllib.error
import urllib.request
from datetime import date, datetime, timezone
from typing import Any

EVENTS_URL = "https://cursor.com/api/dashboard/get-filtered-usage-events"
REQUEST_TIMEOUT_SECONDS = 15

try:
    from datetime import UTC
except ImportError:
    UTC = timezone.utc


def parse_datetime(value: Any) -> datetime | None:
    if value is None:
        return None
    if isinstance(value, (int, float)):
        ts = float(value)
        if ts > 1e12:
            ts /= 1000.0
        return datetime.fromtimestamp(ts, tz=UTC)
    if isinstance(value, str):
        text = value.strip()
        if not text:
            return None
        if text.endswith("Z"):
            text = text[:-1] + "+00:00"
        try:
            dt = datetime.fromisoformat(text)
            if dt.tzinfo is None:
                dt = dt.replace(tzinfo=UTC)
            return dt
        except ValueError:
            return None
    return None


def fetch_filtered_events(
    session_token: str,
    team_id: int,
    start_ms: str,
    end_ms: str,
    page: int = 1,
    page_size: int = 100,
) -> dict[str, Any]:
    body = json.dumps(
        {
            "teamId": team_id,
            "startDate": start_ms,
            "endDate": end_ms,
            "page": page,
            "pageSize": page_size,
        }
    )
    request = urllib.request.Request(
        EVENTS_URL,
        data=body.encode("utf-8"),
        headers={
            "Accept": "*/*",
            "Content-Type": "application/json",
            "Cookie": f"WorkosCursorSessionToken={session_token}",
            "User-Agent": (
                "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) "
                "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36"
            ),
        },
        method="POST",
    )
    with urllib.request.urlopen(request, timeout=REQUEST_TIMEOUT_SECONDS) as response:
        return json.load(response)


def fetch_all_events_in_range(
    session_token: str,
    team_id: int,
    start: datetime,
    end: datetime,
) -> list[dict[str, Any]]:
    start_ms = str(int(start.timestamp() * 1000))
    end_ms = str(int(end.timestamp() * 1000))
    all_events: list[dict[str, Any]] = []
    page = 1
    while True:
        data = fetch_filtered_events(
            session_token, team_id, start_ms, end_ms, page=page, page_size=100
        )
        events = data.get("usageEventsDisplay", [])
        all_events.extend(events)
        total_count = data.get("totalUsageEventsCount", 0)
        if len(all_events) >= total_count or not events:
            break
        page += 1
    return all_events


def sum_charged_cents(
    events: list[dict[str, Any]], start: datetime, end: datetime
) -> tuple[int, int]:
    total = 0.0
    count = 0
    for event in events:
        ts = parse_datetime(event.get("timestamp"))
        if ts is None or ts < start or ts >= end:
            continue
        charged = event.get("chargedCents")
        if charged is None:
            continue
        total += float(charged)
        count += 1
    return int(round(total)), count


def month_start_local(day: date) -> datetime:
    local_tz = datetime.now().astimezone().tzinfo
    return datetime(day.year, day.month, 1, tzinfo=local_tz)


def resolve_month_used_cents(
    *,
    cycle_used_cents: int,
    cycle_start: date,
    month_start: date,
    today: date,
    session_token: str,
    team_id: int,
) -> tuple[int, str]:
    """Return spend for the current calendar month using billing cycle + events."""
    if cycle_start >= month_start:
        return cycle_used_cents, "billing_cycle"

    now_local = datetime.now().astimezone()
    month_start_dt = month_start_local(today)
    try:
        events = fetch_all_events_in_range(
            session_token,
            team_id,
            month_start_dt,
            now_local,
        )
        cents, _ = sum_charged_cents(events, month_start_dt, now_local)
        return cents, "events"
    except (urllib.error.URLError, urllib.error.HTTPError, json.JSONDecodeError, OSError):
        return cycle_used_cents, "billing_cycle_fallback"
