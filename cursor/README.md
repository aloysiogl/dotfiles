# Cursor

Cursor editor config. The **source of truth** for `settings.json` and `keybindings.json` lives in this folder; Cursor’s config directory should use symlinks to these files.

## Files

| File               | Description                    |
|--------------------|--------------------------------|
| `settings.json`    | Editor settings and preferences |
| `keybindings.json` | Custom keybindings             |
| `extensions.txt`   | List of extensions to install  |
| `install.sh`       | Installs extensions and symlinks config |

## Install

1. Ensure Cursor’s user config directory exists:

   ```bash
   mkdir -p ~/Library/Application\ Support/Cursor/User
   ```

2. Create symlinks so this repo is the source of truth (backup existing files first if you care):

   ```bash
   ln -sf ~/.dotfiles/cursor/settings.json ~/Library/Application\ Support/Cursor/User/settings.json
   ln -sf ~/.dotfiles/cursor/keybindings.json ~/Library/Application\ Support/Cursor/User/keybindings.json
   ```

   Or run the install script from the repo root (e.g. via bootstrap or manually):

   ```bash
   .dotfiles/cursor/install.sh
   ```

3. After linking, edit `~/.dotfiles/cursor/settings.json` and `~/.dotfiles/cursor/keybindings.json`; Cursor will use those files. Changes here stay in sync with your editor.

## Finding the right command for a shortcut

If a keybinding doesn’t work (e.g. “add selection to chat”), find the real command ID:

1. **Cmd+Shift+P** → **“Preferences: Open Keyboard Shortcuts”** (or **Cmd+K Cmd+S**).
2. In the search box, type **“add”**, **“selection”**, or **“chat”**.
3. Find the action you want (e.g. “Add to Chat”, “Add Selection to Chat”) and note its **Command ID** (e.g. `aichat.insertSelectionIntoFollowup`).
4. Put that ID in `keybindings.json` or in the appropriate `vim.*KeyBindings` entry in `settings.json`.

You can also run **“Developer: Inspect Key Bindings”** and press your key to see which command (if any) is triggered.

## Extensions

`install.sh` also installs extensions listed in `extensions.txt` (one ID per line; lines starting with `#` are ignored). Run it whenever you add or change extensions in that file.

## Usage limiter

Background polling + macOS budget alerts live in [`usage-limiter/`](usage-limiter/README.md). Install separately (or via `script/install`):

```bash
~/.dotfiles/cursor/usage-limiter/install.sh
```
