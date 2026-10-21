local locked = { locked = true }
local release = { release = true }
local locked_repeating = { locked = true, repeating = true }

local function toggle_sysmon()
    local running = false
    for _, w in ipairs(hl.get_windows() or {}) do
        if w.class == "btop" then
            running = true
            break
        end
    end
    if not running then
        hl.dispatch(hl.dsp.exec_cmd("kitty --class btop -e btop", { workspace = "special:sysmon" }))
    end
    hl.dispatch(hl.dsp.workspace.toggle_special("sysmon"))
end

hl.bind("SUPER + SUPER_L", hl.dsp.global("caelestia:launcher"), release)
hl.bind("SUPER + Space", hl.dsp.global("caelestia:launcher"))
hl.bind("SUPER + N", hl.dsp.global("caelestia:sidebar"))
hl.bind("SUPER + K", hl.dsp.global("caelestia:showall"))
hl.bind("CTRL + ALT + Delete", hl.dsp.global("caelestia:session"))
hl.bind("SUPER + L", hl.dsp.global("caelestia:lock"))
hl.bind("SUPER + SHIFT + L", hl.dsp.exec_cmd("systemctl suspend"), locked)

hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind("SUPER + ALT + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind("SUPER + Q", hl.dsp.window.close())

hl.bind("CTRL + SHIFT + Escape", toggle_sysmon)

hl.bind("SUPER + Z", hl.dsp.exec_cmd("kitty"))
hl.bind("SUPER + W", hl.dsp.exec_cmd("librewolf"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("dolphin"))
hl.bind("SUPER + S", hl.dsp.exec_cmd("steam"))

hl.bind("SUPER + SHIFT + ALT + S", hl.dsp.global("caelestia:screenshot"))

hl.bind("SUPER + V", hl.dsp.exec_cmd("pkill fuzzel || caelestia clipboard"))
hl.bind("SUPER + Period", hl.dsp.exec_cmd("pkill fuzzel || caelestia emoji -p"))

hl.bind("XF86MonBrightnessUp", hl.dsp.global("caelestia:brightnessUp"), locked)
hl.bind("XF86MonBrightnessDown", hl.dsp.global("caelestia:brightnessDown"), locked)
hl.bind("XF86AudioPlay", hl.dsp.global("caelestia:mediaToggle"), locked)
hl.bind("XF86AudioPause", hl.dsp.global("caelestia:mediaToggle"), locked)
hl.bind("XF86AudioNext", hl.dsp.global("caelestia:mediaNext"), locked)
hl.bind("XF86AudioPrev", hl.dsp.global("caelestia:mediaPrev"), locked)
hl.bind("XF86AudioStop", hl.dsp.global("caelestia:mediaStop"), locked)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), locked)
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), locked)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 1%+"), locked_repeating)
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"), locked_repeating)
