#!/bin/sh
#
# Install Cursor: symlink settings/keybindings (source of truth in dotfiles) and install extensions from extensions.txt.

CURSOR_DIR="$(dirname "$0")"
EXTENSIONS_FILE="$CURSOR_DIR/extensions.txt"
CURSOR_USER="${XDG_CONFIG_HOME:-$HOME/Library/Application Support}/Cursor/User"

# Symlink config so dotfiles are the source of truth
mkdir -p "$CURSOR_USER"
ln -sf "$CURSOR_DIR/settings.json" "$CURSOR_USER/settings.json"
ln -sf "$CURSOR_DIR/keybindings.json" "$CURSOR_USER/keybindings.json"
echo "  Cursor config symlinked (settings.json, keybindings.json)."

if ! command -v cursor > /dev/null 2>&1; then
  echo "  cursor CLI not found. Skipping extension install."
  exit 0
fi

echo "  Installing Cursor extensions..."

while IFS= read -r extension || [ -n "$extension" ]; do
  # Skip empty lines and comments
  [ -z "$extension" ] && continue
  [[ "$extension" == \#* ]] && continue

  echo "  Installing $extension..."
  cursor --install-extension "$extension" --force
done < "$EXTENSIONS_FILE"

echo "  Cursor extensions installed."
