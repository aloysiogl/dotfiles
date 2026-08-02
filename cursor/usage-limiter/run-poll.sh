#!/usr/bin/env bash
# Wrapper for the LaunchAgent.
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"

exec python3 "${DIR}/poll.py"
