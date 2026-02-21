#!/bin/sh

# Set XDG defaults for this system
if ! command -v xdg-mime >/dev/null 2>&1; then
  exit 0
fi

pdf_desktop="org.kde.okular.desktop"

if [ ! -f "/usr/share/applications/${pdf_desktop}" ] && \
   [ ! -f "$HOME/.local/share/applications/${pdf_desktop}" ]; then
  pdf_desktop="okular.desktop"
fi

xdg-mime default "$pdf_desktop" application/pdf

# Set Firefox as default browser
browser_desktop="org.mozilla.firefox.desktop"

if [ ! -f "/usr/share/applications/${browser_desktop}" ] && \
   [ ! -f "$HOME/.local/share/applications/${browser_desktop}" ] && \
   [ ! -f "/var/lib/flatpak/exports/share/applications/${browser_desktop}" ]; then
  # Try alternative Firefox desktop file names
  if [ -f "/usr/share/applications/firefox.desktop" ] || \
     [ -f "$HOME/.local/share/applications/firefox.desktop" ]; then
    browser_desktop="firefox.desktop"
  elif [ -f "/usr/share/applications/firefox-esr.desktop" ] || \
       [ -f "$HOME/.local/share/applications/firefox-esr.desktop" ]; then
    browser_desktop="firefox-esr.desktop"
  fi
fi

# Set default browser for various MIME types and URL schemes
xdg-mime default "$browser_desktop" text/html
xdg-mime default "$browser_desktop" x-scheme-handler/http
xdg-mime default "$browser_desktop" x-scheme-handler/https
xdg-mime default "$browser_desktop" x-scheme-handler/about
xdg-mime default "$browser_desktop" x-scheme-handler/unknown

# Set Nautilus as default file manager for directories
file_manager_desktop="org.gnome.Nautilus.desktop"

if [ ! -f "/usr/share/applications/${file_manager_desktop}" ] && \
   [ ! -f "$HOME/.local/share/applications/${file_manager_desktop}" ] && \
   [ ! -f "/var/lib/flatpak/exports/share/applications/${file_manager_desktop}" ]; then
  if [ -f "/usr/share/applications/nautilus.desktop" ] || \
     [ -f "$HOME/.local/share/applications/nautilus.desktop" ] || \
     [ -f "/var/lib/flatpak/exports/share/applications/nautilus.desktop" ]; then
    file_manager_desktop="nautilus.desktop"
  fi
fi

xdg-mime default "$file_manager_desktop" inode/directory
