"""Calendar-month budget helpers with optional weekdays-only allocation."""

from __future__ import annotations

from datetime import date, datetime, timedelta


def is_weekday(day: date) -> bool:
    return day.weekday() < 5


def count_weekdays(start: date, end: date) -> int:
    if end < start:
        return 0
    count = 0
    current = start
    while current <= end:
        if is_weekday(current):
            count += 1
        current += timedelta(days=1)
    return count


def month_bounds(day: date) -> tuple[date, date]:
    start = day.replace(day=1)
    if day.month == 12:
        end = date(day.year + 1, 1, 1) - timedelta(days=1)
    else:
        end = date(day.year, day.month + 1, 1) - timedelta(days=1)
    return start, end


def parse_cycle_dates(payload: dict) -> tuple[date, date]:
    start = datetime.fromisoformat(
        payload["billingCycleStart"].replace("Z", "+00:00")
    ).astimezone().date()
    end = datetime.fromisoformat(
        payload["billingCycleEnd"].replace("Z", "+00:00")
    ).astimezone().date()
    return start, end


def budget_window(
    month_start: date,
    month_end: date,
    cycle_start: date,
    cycle_end: date,
) -> tuple[date, date]:
    """Intersection of the calendar month and the billing cycle."""
    return max(month_start, cycle_start), min(month_end, cycle_end)


def window_weekday_stats(
    today: date,
    window_start: date,
    window_end: date,
) -> dict[str, int | bool]:
    total = count_weekdays(window_start, window_end)
    elapsed = count_weekdays(window_start, min(today, window_end))
    remaining = count_weekdays(today, window_end) if today <= window_end else 0
    return {
        "window_start": window_start.isoformat(),
        "window_end": window_end.isoformat(),
        "weekdays_total": max(total, 1),
        "weekdays_elapsed": max(elapsed, 0),
        "weekdays_remaining": max(remaining, 0),
        "is_weekend_today": not is_weekday(today),
    }


def month_weekday_stats(today: date) -> dict[str, int | bool]:
    month_start, month_end = month_bounds(today)
    return window_weekday_stats(today, month_start, month_end)


def compute_budget_targets(
    *,
    monthly_target_cents: int,
    period_used_cents: int,
    today: date,
    weekdays_only: bool,
    window_start: date | None = None,
    window_end: date | None = None,
) -> dict[str, int | float | bool]:
    if window_start is None or window_end is None:
        window_start, window_end = month_bounds(today)

    stats = (
        window_weekday_stats(today, window_start, window_end)
        if weekdays_only
        else _all_day_stats(today, window_start, window_end)
    )
    remaining_budget_cents = max(monthly_target_cents - period_used_cents, 0)

    if weekdays_only:
        weekdays_total = int(stats["weekdays_total"])
        weekdays_elapsed = int(stats["weekdays_elapsed"])
        weekdays_remaining = int(stats["weekdays_remaining"])
        is_weekend = bool(stats["is_weekend_today"])

        if is_weekend:
            daily_target_cents = 0
        else:
            divisor = max(weekdays_remaining, 1)
            daily_target_cents = max(int(remaining_budget_cents / divisor), 1)

        expected_cents = int(
            monthly_target_cents * weekdays_elapsed / weekdays_total
        )
        return {
            **stats,
            "period_used_cents": period_used_cents,
            "remaining_budget_cents": remaining_budget_cents,
            "daily_target_cents": daily_target_cents,
            "expected_cents": expected_cents,
            "weekdays_only": True,
        }

    days_in_window = (window_end - window_start).days + 1
    days_elapsed = (min(today, window_end) - window_start).days + 1
    days_remaining = max(days_in_window - days_elapsed + 1, 1)
    daily_target_cents = max(int(remaining_budget_cents / days_remaining), 1)

    return {
        **stats,
        "period_used_cents": period_used_cents,
        "remaining_budget_cents": remaining_budget_cents,
        "daily_target_cents": daily_target_cents,
        "expected_cents": int(monthly_target_cents * days_elapsed / days_in_window),
        "weekdays_only": False,
        "days_in_window": days_in_window,
        "days_elapsed": days_elapsed,
        "days_remaining": days_remaining,
    }


def _all_day_stats(
    today: date,
    window_start: date,
    window_end: date,
) -> dict[str, int | bool | str]:
    days_in_window = (window_end - window_start).days + 1
    days_elapsed = (min(today, window_end) - window_start).days + 1
    days_remaining = max(days_in_window - days_elapsed + 1, 1)
    return {
        "window_start": window_start.isoformat(),
        "window_end": window_end.isoformat(),
        "weekdays_total": max(days_in_window, 1),
        "weekdays_elapsed": max(days_elapsed, 0),
        "weekdays_remaining": max(days_remaining, 0),
        "is_weekend_today": not is_weekday(today),
    }


def local_today() -> date:
    return datetime.now().astimezone().date()
