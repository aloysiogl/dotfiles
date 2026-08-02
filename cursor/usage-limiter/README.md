# Cursor Usage Limiter

Background daemon that polls Cursor usage on a configurable interval (default every 10 minutes) and shows macOS alerts at daily budget thresholds (60%, 80%, 100%).

## Install

```bash
~/.dotfiles/cursor/usage-limiter/install.sh
```

Or via the main dotfiles bootstrap (`script/install` runs all `install.sh` files).

This will:

- Symlink scripts to `~/.cursor/usage-limiter/`
- Register a LaunchAgent (`com.cursor.usage-limiter`) that polls on the interval in `config.json`
- Wire the Cursor CLI status line to `statusline.sh`

## Auth

Keep the token in `~/.localrc`, the repository's macOS convention for machine-specific environment variables:

```zsh
export CURSOR_SESSION_TOKEN='...'
```

Token resolution order in `poll.py`:

1. `CURSOR_SESSION_TOKEN` environment variable (interactive runs)
2. `CURSOR_SESSION_TOKEN` in `~/.localrc` (used by the LaunchAgent)

`CURSOR_TEAM_ID` from your shell env overrides `config.json` when set.

## Commands

```bash
# Dashboard
python3 ~/.cursor/usage-limiter/status.py

# Set monthly budget ($700/month)
~/.cursor/usage-limiter/set-budget.sh 700

# Manual poll
python3 ~/.cursor/usage-limiter/poll.py

# Re-fire alerts (clears today's flags + polls)
~/.cursor/usage-limiter/trigger-alert.sh

# Logs
tail -f ~/.cursor/usage-limiter/limiter.log
```

## Config

Edit `config.json` in this folder (symlinked to runtime):

```json
{
  "team_id": 18803605,
  "monthly_target_cents": 70000,
  "poll_interval_seconds": 600,
  "alert_thresholds": [60, 80, 100],
  "weekdays_only": true
}
```

`monthly_target_cents` is in cents — `70000` = $700/month.

### Weekdays-only mode (`weekdays_only: true`)

Budget and pace use the **current calendar month**, clipped to your **Cursor billing cycle**, counting **Monday–Friday only**:

- **Month spend** = billing-cycle total when the cycle started this month; otherwise summed from usage events since the 1st
- **Daily budget** = remaining month budget ÷ remaining weekdays in the budget window
- **Month pace** = expected spend by weekday progress in the window
- **Weekends** = no daily budget, no alerts
- **Billing cycle total** shown separately for reference

Set `"weekdays_only": false` to split across all days in the budget window.

## Alerts

Native macOS dialogs via `alert.swift`:

- **60%** — yellow warning
- **80%** — orange warning
- **100%** — red critical, suggests pausing Cursor

Alerts reset at local midnight.

## Token refresh

When the session JWT expires you'll get an auth-failure alert. Refresh:

1. Open [cursor.com/dashboard/usage](https://cursor.com/dashboard/usage)
2. DevTools → Application → Cookies → `cursor.com` → copy `WorkosCursorSessionToken`
3. Update `CURSOR_SESSION_TOKEN` in `~/.localrc`

Then restart the daemon:

```bash
launchctl kickstart -k gui/$(id -u)/com.cursor.usage-limiter
```
