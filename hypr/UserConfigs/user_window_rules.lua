-- ==================================================
--  KoolDots (2026)
--  Project URL: https://github.com/LinuxBeginnings
--  License: GNU GPLv3
--  SPDX-License-Identifier: GPL-3.0-or-later
-- ==================================================

-- User window rule overrides (auto-generated).
-- Add your own rules with apply_window_rule({...})
-- Example:
-- apply_window_rule({
--   name = "My Float Rule",
--   match = { class = "^pavucontrol$" },
--   float = true,
--   center = true,
-- })

local user_window_rules_helper = nil
do
  local source = (debug.getinfo(1, "S") or {}).source or ""
  local source_path = source:match("^@(.+)$")
  local source_dir = source_path and source_path:match("^(.*)/[^/]+$") or nil
  local home = os.getenv("HOME") or ""
  local candidate_paths = {
    source_dir and (source_dir .. "/../lua/user_window_rules_helper.lua") or nil,
    home ~= "" and (home .. "/.config/hypr/lua/user_window_rules_helper.lua") or nil,
    home ~= "" and (home .. "/.config/hypr/user_window_rules_helper.lua") or nil,
  }

  local tried_paths = {}
  for _, helper_path in ipairs(candidate_paths) do
    if helper_path then
      table.insert(tried_paths, helper_path)
      local f = io.open(helper_path, "r")
      if f then
        f:close()
        local loaded_ok, loaded_helpers = pcall(dofile, helper_path)
        if loaded_ok and type(loaded_helpers) == "table" and loaded_helpers.apply_window_rule then
          user_window_rules_helper = loaded_helpers
          break
        end
      end
    end
  end

  if not user_window_rules_helper then
    error("Failed to load user_window_rules_helper.lua from: " .. table.concat(tried_paths, ", "))
  end
end
local apply_window_rule = user_window_rules_helper.apply_window_rule

-- Converted from WindowRules.conf
apply_window_rule({
  name = "user-window-windowrule-001",
  match = {
    class = "^([Tt]hunderbird)$",
  },
  workspace = 1,
})

apply_window_rule({
  name = "user-window-windowrule-002",
  match = {
    class = "^(eu.betterbird.Betterbird)$",
  },
  workspace = 1,
})

apply_window_rule({
  name = "user-window-windowrule-003",
  match = {
    class = "^(org.gnome.Evolution)$",
  },
  workspace = 1,
})

apply_window_rule({
  name = "user-window-windowrule-004",
  match = {
    class = "^([Mm]icrosoft-edge(-stable|-beta|-dev|-unstable)?)$",
  },
  workspace = 1,
})

apply_window_rule({
  name = "user-window-windowrule-005",
  match = {
    class = "^([Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr|Mozilla Firefox)$",
  },
  workspace = 1,
})

apply_window_rule({
  name = "user-window-windowrule-006",
  match = {
    class = "firefox$",
  },
  workspace = 1,
})

apply_window_rule({
  name = "user-window-windowrule-007",
  match = {
    class = "^([Mm]icrosoft-edge(-stable|-beta|-dev|-unstable)?)$",
  },
  workspace = 2,
})

apply_window_rule({
  name = "user-window-windowrule-008",
  match = {
    class = "^([Gg]oogle-chrome(-beta|-dev|-unstable)?)$",
  },
  workspace = 2,
})

apply_window_rule({
  name = "user-window-windowrule-009",
  match = {
    class = "^([Tt]horium-browser|[Cc]achy-browser)$",
  },
  workspace = 2,
})

apply_window_rule({
  name = "user-window-windowrule-010",
  match = {
    class = "^(Code|code-insiders|Code - Insiders|code-oss|VSCodium|codium-url-handler)$",
  },
  workspace = 2,
})

apply_window_rule({
  name = "user-window-windowrule-011",
  match = {
    class = "^(Alacritty)$",
  },
  workspace = 3,
})

apply_window_rule({
  name = "user-window-windowrule-012",
  match = {
    class = "^(com.obsproject.Studio)$",
  },
  workspace = 4,
})

apply_window_rule({
  name = "user-window-windowrule-013",
  match = {
    class = "^([Tt]hunar|org.gnome.Nautilus)$",
  },
  workspace = 4,
})

apply_window_rule({
  name = "user-window-windowrule-014",
  match = {
    class = "^([Ss]team)$",
  },
  workspace = 5,
})

apply_window_rule({
  name = "user-window-windowrule-015",
  match = {
    class = "^([Ll]utris)$",
  },
  workspace = 5,
})

apply_window_rule({
  name = "user-window-windowrule-016",
  match = {
    class = "^([Dd]iscord|[Ww]ebCord|[Vv]esktop)$",
  },
  workspace = 7,
})

apply_window_rule({
  name = "user-window-windowrule-017",
  match = {
    class = "^([Ss]team)$",
  },
  workspace = 7,
})

apply_window_rule({
  name = "user-window-windowrule-018",
  match = {
    class = "^([Ff]erdium)$",
  },
  workspace = 7,
})

apply_window_rule({
  name = "user-window-windowrule-019",
  match = {
    class = "^([Ww]hatsapp-for-linux)$",
  },
  workspace = 7,
})

apply_window_rule({
  name = "user-window-windowrule-020",
  match = {
    class = "^(teams-for-linux)$",
  },
  workspace = 7,
})

apply_window_rule({
  name = "user-window-windowrule-021",
  match = {
    class = "^(org.pwmt.zathura)$",
  },
  workspace = 7,
})
