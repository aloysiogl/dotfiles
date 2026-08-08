-- ==================================================
--  KoolDots (2026)
--  Project URL: https://github.com/LinuxBeginnings
--  License: GNU GPLv3
--  SPDX-License-Identifier: GPL-3.0-or-later
-- ==================================================

-- User keybind overrides (auto-generated).
-- Add keybinds with bind("MODS", "KEY", fn, opts).
-- Example:
-- bind("SUPER", "Z", exec_cmd("ghostty"), { description = "Launch ghostty" })
-- Helper functions live in ${XDG_CONFIG_HOME:-$HOME/.config}/hypr/lua/user_keybinds_helper.lua so they can be updated separately.
local user_keybinds_helper = nil
do
  local source = (debug.getinfo(1, "S") or {}).source or ""
  local source_path = source:match("^@(.+)$")
  local source_dir = source_path and source_path:match("^(.*)/[^/]+$") or nil
  local home = os.getenv("HOME") or ""
  local candidate_paths = {
    source_dir and (source_dir .. "/../lua/user_keybinds_helper.lua") or nil,
    home ~= "" and (home .. "/.config/hypr/lua/user_keybinds_helper.lua") or nil,
    home ~= "" and (home .. "/.config/hypr/user_keybinds_helper.lua") or nil,
  }

  local tried_paths = {}
  for _, helper_path in ipairs(candidate_paths) do
    if helper_path then
      table.insert(tried_paths, helper_path)
      local f = io.open(helper_path, "r")
      if f then
        f:close()
        local loaded_ok, loaded_helpers = pcall(dofile, helper_path)
        if loaded_ok and type(loaded_helpers) == "table" and loaded_helpers.bind then
          user_keybinds_helper = loaded_helpers
          break
        end
      end
    end
  end

  if not user_keybinds_helper then
    error("Failed to load user_keybinds_helper.lua from: " .. table.concat(tried_paths, ", "))
  end
end
local exec_cmd = user_keybinds_helper.exec_cmd
local dispatch = user_keybinds_helper.dispatch
local bind = user_keybinds_helper.bind
local unbind = user_keybinds_helper.unbind

-- Migrated from the customized UserKeybinds.conf. Remove an upstream binding
-- before replacing it so a single chord never dispatches two actions.
local function override(mods, key, fn, opts)
  unbind(mods, key)
  bind(mods, key, fn, opts)
end

-- Vim-style focus and window movement. SUPER+j/k remain the maintained
-- layout-aware cycle bindings initialized by system_keybinds.lua.
override("SUPER", "h", dispatch("movefocus", "l"))
override("SUPER", "l", dispatch("movefocus", "r"))
override("SUPER", "semicolon", dispatch("movefocus", "r"))
override("SUPER SHIFT", "H", dispatch("movewindow", "l"))
override("SUPER SHIFT", "J", dispatch("movewindow", "d"))
override("SUPER SHIFT", "K", dispatch("movewindow", "u"))
override("SUPER SHIFT", "L", dispatch("movewindow", "r"))
override("SUPER SHIFT", "semicolon", dispatch("movewindow", "r"))

override("SUPER CTRL", "h", dispatch("resizeactive", "-50 0"), { repeating = true })
override("SUPER CTRL", "l", dispatch("resizeactive", "50 0"), { repeating = true })
override("SUPER CTRL", "k", dispatch("resizeactive", "0 -50"), { repeating = true })
override("SUPER CTRL", "j", dispatch("resizeactive", "0 50"), { repeating = true })

override("SUPER", "V", dispatch("layoutmsg", "togglesplit"))
override("SUPER SHIFT", "V", dispatch("layoutmsg", "orientationleft"))

-- Resize submap (SUPER+R, then H/J/K/L or arrows; Enter/Escape exits).
override("SUPER", "R", dispatch("submap", "resize"))
hl.define_submap("resize", function()
  bind("", "H", dispatch("resizeactive", "-10 0"), { repeating = true })
  bind("", "J", dispatch("resizeactive", "0 -10"), { repeating = true })
  bind("", "K", dispatch("resizeactive", "0 10"), { repeating = true })
  bind("", "L", dispatch("resizeactive", "10 0"), { repeating = true })
  bind("", "left", dispatch("resizeactive", "-10 0"), { repeating = true })
  bind("", "down", dispatch("resizeactive", "0 10"), { repeating = true })
  bind("", "up", dispatch("resizeactive", "0 -10"), { repeating = true })
  bind("", "right", dispatch("resizeactive", "10 0"), { repeating = true })
  bind("", "Return", dispatch("submap", "reset"))
  bind("", "Escape", dispatch("submap", "reset"))
  bind("SUPER", "R", dispatch("submap", "reset"))
end)

-- Move-workspace submap (SUPER+Z, then H/J/K/L; Enter/Escape exits).
override("SUPER", "Z", dispatch("submap", "move_workspace"))
hl.define_submap("move_workspace", function()
  bind("", "H", dispatch("movecurrentworkspacetomonitor", "l"))
  bind("", "L", dispatch("movecurrentworkspacetomonitor", "r"))
  bind("", "J", dispatch("movecurrentworkspacetomonitor", "d"))
  bind("", "K", dispatch("movecurrentworkspacetomonitor", "u"))
  bind("", "Return", dispatch("submap", "reset"))
  bind("", "Escape", dispatch("submap", "reset"))
  bind("SUPER", "Z", dispatch("submap", "reset"))
end)

override("ALT", "SPACE", exec_cmd("pkill rofi || true && rofi -show combi -config ~/.config/rofi/config"))
override("ALT", "XF86Launch3", exec_cmd("systemctl suspend"), { description = "Suspend computer" })

-- Preserve the i3-like window behavior from the old user config.
override("SUPER", "F", dispatch("fullscreen", ""))
override("SUPER", "S", dispatch("togglefloating", ""))
override("SUPER", "P", dispatch("pseudo", ""))
override("SUPER ALT", "V", exec_cmd("$HOME/.config/hypr/scripts/ClipManager.sh"))
override("SUPER CTRL", "F", dispatch("fullscreen", "1"))
override("SUPER SHIFT", "Return", exec_cmd("$HOME/.config/hypr/scripts/Dropterminal.sh alacritty"))
unbind("SUPER", "H")

-- Restore PrintScreen without requiring SUPER.
unbind("SUPER", "Print")
unbind("SUPER SHIFT", "Print")
unbind("SUPER CTRL", "Print")
unbind("SUPER CTRL SHIFT", "Print")
override("", "Print", exec_cmd("$HOME/.config/hypr/scripts/ScreenShot.sh --now"), { description = "Screenshot now" })
override("SHIFT", "Print", exec_cmd("$HOME/.config/hypr/scripts/ScreenShot.sh --area"), { description = "Screenshot area" })
override("CTRL", "Print", exec_cmd("$HOME/.config/hypr/scripts/ScreenShot.sh --in5"), { description = "Screenshot in 5 seconds" })
override("CTRL SHIFT", "Print", exec_cmd("$HOME/.config/hypr/scripts/ScreenShot.sh --in10"), { description = "Screenshot in 10 seconds" })
override("ALT", "Print", exec_cmd("$HOME/.config/hypr/scripts/ScreenShot.sh --active"), { description = "Screenshot active window" })
