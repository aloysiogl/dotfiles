# Dotfiles Repository Instructions

## Architecture Overview

This is a **topic-based dotfiles system** (forked from holman/dotfiles) designed for cross-platform configuration management (macOS and Linux/Arch). Each application/tool lives in its own topic directory with a consistent file naming convention.

### Core Concepts

**Topic Directory Structure**: Each directory represents a configuration "topic" (e.g., `git/`, `nvim/`, `zsh/`). The system automatically discovers and processes files based on naming conventions:

- `*.symlink` → Symlinked to `$HOME/.{filename}` by `script/bootstrap`
- `*.zsh` → Auto-loaded into ZSH environment (except special cases below)
- `path.zsh` → Loaded first for PATH setup
- `completion.zsh` → Loaded last for autocomplete configuration
- `install.sh` → Executed by `script/install` for topic-specific setup
- `bin/*` → Executables added to PATH automatically

**DOTFILES_ROOT**: Environment variable pointing to `~/.dotfiles`, used throughout scripts. Set in [zsh/zshrc_linux.symlink](zsh/zshrc_linux.symlink#L1) and [zsh/zshrc_mac.symlink](zsh/zshrc_mac.symlink#L11).

## Key Workflows

### Initial Setup
```bash
git clone https://github.com/aloysiogl/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/bootstrap  # Creates symlinks and sets up git config
script/install    # Runs all topic/install.sh scripts
```

**Bootstrap flow** ([script/bootstrap](script/bootstrap)):
1. Prompts for git author name/email, creates `git/gitconfig.local.symlink`
2. Finds all `*.symlink` files (maxdepth 2), symlinks to `$HOME/.{basename}`
3. On macOS, runs `bin/dot` for homebrew/dependencies

### Package Management

**Linux (Arch)**: Uses [Nix package manager](nix/config.nix) for primary packages. See `nix/config.nix` for declarative package list. Also uses:
- `apt/packages.txt` - APT packages list
- `pacman/arch-packages.txt` - Pacman packages list
- `flatpak/flatpaks.txt` - Flatpak applications

**macOS**: Uses Homebrew. See [homebrew/Brewfile](homebrew/Brewfile) for package declarations. Run `bin/dotmac` to update system.

### ZSH Configuration Loading

The ZSH setup is modular and order-dependent ([zsh/zshrc_linux.symlink](zsh/zshrc_linux.symlink#L109-L113)):

```bash
# Loads *.zsh files from these directories in order:
for dir in system zsh nvim git nix; do
  for file in $DOTFILES_ROOT/$dir/*.zsh; do
    source $file
  done
done
```

**Plugin management** ([oh-my-zsh/install.sh](oh-my-zsh/install.sh)): Custom plugins cloned to `~/.oh-my-zsh/custom/plugins/`. Key plugins: `zsh-vi-mode`, `zsh-autosuggestions`, `zsh-syntax-highlighting`, `fzf`.

### Custom Bin Scripts

[bin/dotedit](bin/dotedit): Opens dotfiles in nvim (`dotedit [topic]`)
[bin/dotmac](bin/dotmac): Runs full macOS update (homebrew, installs, defaults)
[bin/dotg](bin/dotg): Git operations within dotfiles directory

## Configuration Patterns

### Adding a New Topic

1. Create `newtopic/` directory
2. Add configuration files:
   - `config.symlink` → Will symlink to `~/.config`
   - `aliases.zsh` → Auto-loaded into shell
   - `install.sh` → Install dependencies (e.g., clone repos, install packages)
3. Run `script/bootstrap` to create symlinks
4. Run `script/install` to execute install script

### Modifying Existing Configurations

**Don't edit symlinked files directly in $HOME** - edit source files in `~/.dotfiles/topic/`.

**After changes**:
- ZSH files: `reload!` alias (sources `~/.zshrc`)
- Symlinks: Re-run `script/bootstrap` if adding new `.symlink` files
- Install scripts: Re-run `script/install`

### Cross-Platform Handling

Two separate ZSH configs: [zsh/zshrc_mac.symlink](zsh/zshrc_mac.symlink) and [zsh/zshrc_linux.symlink](zsh/zshrc_linux.symlink)

Platform detection in scripts:
```bash
if [ "$(uname -s)" == "Darwin" ]; then
  # macOS-specific code
fi
```

## Important Files

- [script/bootstrap](script/bootstrap): Main symlinking and setup script
- [system/_path.zsh](system/_path.zsh): Adds `bin/` to PATH
- [system/aliases.zsh](system/aliases.zsh): Global aliases (`cat='bat'`, `grep='rg'`)
- [zsh/fpath.zsh](zsh/fpath.zsh): Loads functions from `functions/` directory
- [git/gitconfig.symlink](git/gitconfig.symlink): Git config (uses delta for diffs)

## Technology Stack

- **Shell**: ZSH with Oh-My-Zsh + Powerlevel10k theme
- **Editor**: Neovim (configured in `nvim/`)
- **Terminal**: Alacritty (Linux), iTerm2 (macOS)
- **Window Manager**: Hyprland (Linux), Yabai+SKHD (macOS)
- **Tools**: bat (cat), ripgrep (grep), zoxide (cd), lazygit, fzf, delta (git diff)

## Current State & TODOs

**Manual Linux installation**: The Ubuntu install process is currently manual ([README.md](README.md#L31-L45)). Install order matters: Nix → ZSH → Oh-my-zsh → individual tools.

See [TODO.md](TODO.md) for active improvement tasks (rofi, firefox, tmux shortcuts).

## Notes

- Environment variables (API keys) loaded from `~/.env` (not in repo)
- Git credentials stored via credential.helper=store (see [git/gitconfig.symlink](git/gitconfig.symlink#L23))
- Functions in `functions/` are auto-loaded via [zsh/fpath.zsh](zsh/fpath.zsh#L4)
