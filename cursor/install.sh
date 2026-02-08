#!/bin/sh
#
# Install Cursor extensions from extensions.txt

EXTENSIONS_FILE="$(dirname "$0")/extensions.txt"

if ! command -v cursor &> /dev/null; then
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
