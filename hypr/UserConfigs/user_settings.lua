-- ==================================================
--  KoolDots (2026)
--  Project URL: https://github.com/LinuxBeginnings
--  License: GNU GPLv3
--  SPDX-License-Identifier: GPL-3.0-or-later
-- ==================================================

-- User settings overrides.
-- Keep user-specific settings here so they win over system defaults.

hl.config({
  input = {
    kb_layout = "us",
    kb_variant = "",
    kb_model = "",
    kb_options = "caps:swapescape",
    kb_rules = "",
    repeat_rate = 50,
    repeat_delay = 300,
    numlock_by_default = true,
    left_handed = false,
    follow_mouse = 1,
    float_switch_override_focus = false,
    touchpad = {
      disable_while_typing = true,
      natural_scroll = true,
      clickfinger_behavior = false,
      middle_button_emulation = true,
      tap_to_click = true,
      drag_lock = false,
    },
  },
})

hl.config({
  dwindle = {
    preserve_split = true,
    special_scale_factor = 0.8,
  },
  master = {
    new_on_top = true,
    mfact = 0.5,
  },
  general = {
    resize_on_border = true,
    layout = "dwindle",
  },
})

hl.config({
  gestures = {
    workspace_swipe_distance = 400,
    workspace_swipe_invert = true,
    workspace_swipe_min_speed_to_force = 30,
    workspace_swipe_cancel_ratio = 0.5,
    workspace_swipe_create_new = true,
    workspace_swipe_forever = true,
  },
})

hl.config({
  misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    mouse_move_enables_dpms = true,
    enable_swallow = false,
    focus_on_activate = false,
    swallow_regex = "^(kitty)$",
  },
  binds = {
    workspace_back_and_forth = true,
    allow_workspace_cycles = true,
    pass_mouse_when_bound = false,
  },
  xwayland = {
    force_zero_scaling = true,
  },
})

-- Source reference from UserSettings.conf (hyprlang):
-- dwindle {
-- preserve_split = yes
-- special_scale_factor = 0.8
-- }
-- master {
-- new_on_top = 1
-- mfact = 0.5
-- }
-- general {
-- resize_on_border = true
-- layout = dwindle
-- }
-- input {
-- kb_layout = us
-- kb_variant =
-- kb_model =
-- kb_options = caps:swapescape
-- kb_rules =
-- repeat_rate = 50
-- repeat_delay = 300
-- numlock_by_default = true
-- left_handed = false
-- follow_mouse = true
-- float_switch_override_focus = false
-- touchpad {
-- disable_while_typing = true
-- natural_scroll = true
-- clickfinger_behavior = false
-- middle_button_emulation = true
-- tap-to-click = true
-- drag_lock = false
-- }
-- }
-- gestures {
-- workspace_swipe_distance=400
-- workspace_swipe_invert=true
-- workspace_swipe_min_speed_to_force=30
-- workspace_swipe_cancel_ratio=0.5
-- workspace_swipe_create_new=true
-- workspace_swipe_forever=true
-- }
-- misc {
-- disable_hyprland_logo = true
-- disable_splash_rendering = true
-- mouse_move_enables_dpms = true
-- enable_swallow = false
-- focus_on_activate = false
-- swallow_regex = ^(kitty)$
-- }
-- binds {
-- workspace_back_and_forth=true
-- allow_workspace_cycles=true
-- pass_mouse_when_bound=false
-- }
-- xwayland {
-- force_zero_scaling = true
-- }
