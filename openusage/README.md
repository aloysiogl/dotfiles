# OpenUsage

[OpenUsage](https://github.com/janekbaraniewski/openusage) is the local
terminal dashboard for usage across Codex, Claude Code, Cursor, and other AI
tools.

## Install

Run the topic installer directly:

```bash
~/.dotfiles/openusage/install.sh
```

It is also run by the repository's main `script/install` command. The
installer:

- downloads the latest upstream release and verifies its published checksum;
- installs the binary to `~/.local/bin/openusage`;
- installs the local OpenUsage daemon with the platform's user service manager;
- registers the official Claude Code and Codex telemetry hooks when those
  commands are available.

Cursor has no hook integration. OpenUsage discovers its local state database
automatically.

Set `OPENUSAGE_INSTALL_DAEMON=0` when running the installer to skip the daemon.

## Commands

```bash
# Concise Claude Code, Codex, and Cursor usage summary
ou

# Full interactive dashboard and built-in reports
openusage
openusage daily
openusage session
openusage integrations list --all
openusage telemetry daemon status
```

OpenUsage's built-in compact renderer selects only the most recently active
provider. The dotfiles-provided `ou` command instead reads the export and
prints the relevant quota windows for Claude Code, Codex, and Cursor. A client
that is not installed and authenticated is shown as `NOT DETECTED`.

OpenUsage keeps its mutable, machine-specific state outside the dotfiles:

- `~/.config/openusage/settings.json`
- `~/.local/state/openusage/telemetry.db`

It has no OpenUsage telemetry or analytics backend. It contacts configured AI
providers to read quota and billing information; hook events remain on the
local Unix socket and SQLite database.
