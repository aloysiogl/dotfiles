#!/bin/bash

# --- Configuration ---
SOURCE_DIR="$HOME/.config/hypr"

if [ -z "${DOTFILES_ROOT:-}" ]; then
    echo "Error: DOTFILES_ROOT is not set. Please source your shell config first."
    exit 1
fi

DOTFILES_DIR="$DOTFILES_ROOT"
DEST_DIR="$DOTFILES_DIR/hypr"

# 1. Check if the source config actually exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory $SOURCE_DIR does not exist."
    exit 1
fi

# 2. Check if it is already a symbolic link (idempotency)
if [ -L "$SOURCE_DIR" ]; then
    echo "Error: $SOURCE_DIR is already a symbolic link."
    echo "It looks like you might have already run this script."
    exit 1
fi

# 3. If destination exists, remove it after moving this script out
TEMP_DIR=""
TEMP_SCRIPT=""
SCRIPT_PATH=$(readlink -f "$0" 2>/dev/null || realpath "$0" 2>/dev/null || echo "$0")

if [ -d "$DEST_DIR" ]; then
    TEMP_DIR=$(mktemp -d)
    TEMP_SCRIPT="$TEMP_DIR/$(basename "$SCRIPT_PATH")"

    if [ -f "$SCRIPT_PATH" ] && [ "$(dirname "$SCRIPT_PATH")" = "$DEST_DIR" ]; then
        mv "$SCRIPT_PATH" "$TEMP_SCRIPT"
    else
        cp "$SCRIPT_PATH" "$TEMP_SCRIPT"
    fi

    rm -rf "$DEST_DIR"
fi

# --- Execution ---

mv "$SOURCE_DIR" "$DEST_DIR"

if [ $? -eq 0 ]; then
    echo " -> Move successful."
else
    echo " -> Move failed! Aborting to prevent data loss."
    exit 1
fi

echo "Step 3: Creating symbolic link..."
ln -s "$DEST_DIR" "$SOURCE_DIR"

if [ -n "$TEMP_SCRIPT" ] && [ -f "$TEMP_SCRIPT" ]; then
    mv "$TEMP_SCRIPT" "$DEST_DIR/$(basename "$TEMP_SCRIPT")"
fi

echo "------------------------------------------------"
echo "Success! Your setup is complete."
echo "Original location: $SOURCE_DIR (now a link)"
echo "Real location:     $DEST_DIR"
echo "------------------------------------------------"