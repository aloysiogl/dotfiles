-- ==================================================
--  KoolDots (2026)
--  Project URL: https://github.com/LinuxBeginnings
--  License: GNU GPLv3
--  SPDX-License-Identifier: GPL-3.0-or-later
-- ==================================================

-- System Laptops (auto-generated).
-- This file keeps migrated settings split from user overrides.
-- Add only Lua entries here.
-- Example:
-- hl.config({ general = { gaps_in = 4, gaps_out = 8 } })

-- Source reference from Laptops.conf (hyprlang):
-- $mainMod = SUPER
-- $scriptsDir = $HOME/.config/hypr/scripts
-- $UserConfigs = $HOME/.config/hypr/UserConfigs
-- $Touchpad_Device=asue1209:00-04f3:319f-touchpad
-- binde = , xf86KbdBrightnessDown, exec, $scriptsDir/BrightnessKbd.sh --dec # decrease keyboard brightness
-- binde = , xf86KbdBrightnessUp, exec, $scriptsDir/BrightnessKbd.sh --inc # increase keyboard brightness
-- bind = , xf86Launch1, exec, rog-control-center # ASUS Armory crate button
-- bind = , xf86Launch3, exec, asusctl led-mode -n # FN+F4 Switch keyboard RGB profile
-- bind = , xf86Launch4, exec, asusctl profile -n  # FN+F5 change of fan profiles (Quite, Balance, Performance)
-- binde = , xf86MonBrightnessDown, exec, $scriptsDir/Brightness.sh --dec # decrease monitor brightness
-- binde = , xf86MonBrightnessUp, exec, $scriptsDir/Brightness.sh --inc # increase monitor brightness
-- bind = , xf86TouchpadToggle, exec, $scriptsDir/TouchPad.sh # disable touchpad
-- bind = $mainMod, F6, exec, $scriptsDir/ScreenShot.sh --now # screenshot
-- bind = $mainMod SHIFT, F6, exec, $scriptsDir/ScreenShot.sh --area # screenshot (area)
-- bind = $mainMod CTRL, F6, exec, $scriptsDir/ScreenShot.sh --in5 # # screenshot (5 secs delay)
-- bind = $mainMod ALT, F6, exec, $scriptsDir/ScreenShot.sh --in10 # screenshot (10 secs delay)
-- bind = ALT, F6, exec, $scriptsDir/ScreenShot.sh --active # screenshot (active window only)
-- $TOUCHPAD_ENABLED = true
-- device {
-- name = $Touchpad_Device
-- enabled = $TOUCHPAD_ENABLED
-- }

-- Active conversion of the laptop bindings above. The migration helper left
-- this block as comments even though the source entries were enabled.
local function laptop_exec(command)
  return hl.dsp.exec_cmd(command)
end

hl.bind("XF86KbdBrightnessDown", laptop_exec("$HOME/.config/hypr/scripts/BrightnessKbd.sh --dec"), { repeating = true, description = "Decrease keyboard brightness" })
hl.bind("XF86KbdBrightnessUp", laptop_exec("$HOME/.config/hypr/scripts/BrightnessKbd.sh --inc"), { repeating = true, description = "Increase keyboard brightness" })
hl.bind("XF86Launch1", laptop_exec("rog-control-center"), { description = "Open ROG Control Center" })
hl.bind("XF86Launch3", laptop_exec("asusctl led-mode -n"), { description = "Switch keyboard RGB profile" })
hl.bind("XF86Launch4", laptop_exec("asusctl profile -n"), { description = "Change fan profile" })
hl.bind("XF86MonBrightnessDown", laptop_exec("$HOME/.config/hypr/scripts/Brightness.sh --dec"), { repeating = true, description = "Decrease monitor brightness" })
hl.bind("XF86MonBrightnessUp", laptop_exec("$HOME/.config/hypr/scripts/Brightness.sh --inc"), { repeating = true, description = "Increase monitor brightness" })
hl.bind("XF86TouchpadToggle", laptop_exec("$HOME/.config/hypr/scripts/TouchPad.sh"), { description = "Toggle touchpad" })

hl.bind("SUPER + F6", laptop_exec("$HOME/.config/hypr/scripts/ScreenShot.sh --now"), { description = "Take screenshot" })
hl.bind("SUPER + SHIFT + F6", laptop_exec("$HOME/.config/hypr/scripts/ScreenShot.sh --area"), { description = "Take area screenshot" })
hl.bind("SUPER + CTRL + F6", laptop_exec("$HOME/.config/hypr/scripts/ScreenShot.sh --in5"), { description = "Take screenshot after five seconds" })
hl.bind("SUPER + ALT + F6", laptop_exec("$HOME/.config/hypr/scripts/ScreenShot.sh --in10"), { description = "Take screenshot after ten seconds" })
hl.bind("ALT + F6", laptop_exec("$HOME/.config/hypr/scripts/ScreenShot.sh --active"), { description = "Capture active window" })

hl.device({
  name = "asue1209:00-04f3:319f-touchpad",
  enabled = true,
})
