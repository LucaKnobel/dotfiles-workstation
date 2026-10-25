
-- ============================================================
-- Hyprland 0.56 | Keybindings
-- Managed by chezmoi
-- ============================================================

local mod = "SUPER"

-- ============================================================
-- 1. APPLICATIONS
-- ============================================================

hl.bind(mod .. " + Return", hl.dsp.exec_cmd("ghostty"))
hl.bind(mod .. " + D", hl.dsp.exec_cmd("hyprlauncher"))
hl.bind(mod .. " + E", hl.dsp.exec_cmd("nautilus"))
hl.bind(mod .. " + B", hl.dsp.exec_cmd("brave"))
hl.bind(mod .. " + C", hl.dsp.exec_cmd("code"))

-- ============================================================
-- 2. WINDOW MANAGEMENT
-- ============================================================

-- Close active window
hl.bind(
    mod .. " + Q",
    hl.dsp.window.close({})
)

-- Toggle fullscreen
hl.bind(
    mod .. " + F",
    hl.dsp.window.fullscreen({
        mode = "fullscreen",
        action = "toggle",
    })
)

-- Toggle floating
hl.bind(
    mod .. " + SPACE",
    hl.dsp.window.float({
        action = "toggle",
    })
)

-- ============================================================
-- 3. WINDOW FOCUS AND MOVEMENT
-- ============================================================

local directions = {
    LEFT  = "l",
    RIGHT = "r",
    UP    = "u",
    DOWN  = "d",
}

for key, direction in pairs(directions) do
    -- Focus window
    hl.bind(
        mod .. " + " .. key,
        hl.dsp.focus({
            direction = direction,
        })
    )

    -- Move window
    hl.bind(
        mod .. " + SHIFT + " .. key,
        hl.dsp.window.move({
            direction = direction,
        })
    )
end

-- ============================================================
-- 4. WINDOW RESIZING
-- ============================================================

local resize_step = 100

hl.bind(
    mod .. " + CTRL + LEFT",
    hl.dsp.window.resize({
        x = -resize_step,
        y = 0,
        relative = true,
    }),
    { repeating = true }
)

hl.bind(
    mod .. " + CTRL + RIGHT",
    hl.dsp.window.resize({
        x = resize_step,
        y = 0,
        relative = true,
    }),
    { repeating = true }
)

hl.bind(
    mod .. " + CTRL + UP",
    hl.dsp.window.resize({
        x = 0,
        y = -resize_step,
        relative = true,
    }),
    { repeating = true }
)

hl.bind(
    mod .. " + CTRL + DOWN",
    hl.dsp.window.resize({
        x = 0,
        y = resize_step,
        relative = true,
    }),
    { repeating = true }
)

-- ============================================================
-- 5. MOUSE WINDOW CONTROL
-- ============================================================

-- SUPER + left mouse button: move
hl.bind(
    mod .. " + mouse:272",
    hl.dsp.window.drag(),
    { mouse = true }
)

-- SUPER + right mouse button: resize
hl.bind(
    mod .. " + mouse:273",
    hl.dsp.window.resize(),
    { mouse = true }
)

-- ============================================================
-- 6. DWINDLE LAYOUT
-- ============================================================

-- Toggle split direction
hl.bind(
    mod .. " + V",
    hl.dsp.layout("togglesplit")
)

-- Toggle pseudo-tiling
hl.bind(
    mod .. " + P",
    hl.dsp.window.pseudo({
        action = "toggle",
    })
)

-- ============================================================
-- 7. WORKSPACES
-- ============================================================

-- SUPER + 1-9 / 0 = workspace 1-10
-- SHIFT = move active window to workspace

for i = 1, 10 do
    local key = tostring(i % 10)

    hl.bind(
        mod .. " + " .. key,
        hl.dsp.focus({
            workspace = i,
        })
    )

    hl.bind(
        mod .. " + SHIFT + " .. key,
        hl.dsp.window.move({
            workspace = i,
        })
    )
end

-- Relative workspace navigation
hl.bind(
    mod .. " + ALT + UP",
    hl.dsp.focus({
        workspace = "r+1",
    })
)

hl.bind(
    mod .. " + ALT + DOWN",
    hl.dsp.focus({
        workspace = "r-1",
    })
)

-- ============================================================
-- 8. SPECIAL WORKSPACE / SCRATCHPAD
-- ============================================================

-- Toggle special workspace
hl.bind(
    mod .. " + S",
    hl.dsp.workspace.toggle_special("magic")
)

-- Move active window to special workspace
hl.bind(
    mod .. " + SHIFT + S",
    hl.dsp.window.move({
        workspace = "special:magic",
    })
)

-- ============================================================
-- 9. AUDIO
-- ============================================================

-- Increase volume
hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd(
        "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
    ),
    { repeating = true, locked = true }
)

-- Decrease volume
hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd(
        "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    ),
    { repeating = true, locked = true }
)

-- Toggle output mute
hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd(
        "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ),
    { locked = true }
)

-- Toggle microphone mute
hl.bind(
    "XF86AudioMicMute",
    hl.dsp.exec_cmd(
        "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
    ),
    { locked = true }
)

-- ============================================================
-- 10. MEDIA CONTROL
-- ============================================================

hl.bind(
    "XF86AudioPlay",
    hl.dsp.exec_cmd("playerctl play-pause"),
    { locked = true }
)

hl.bind(
    "XF86AudioPause",
    hl.dsp.exec_cmd("playerctl play-pause"),
    { locked = true }
)

hl.bind(
    "XF86AudioNext",
    hl.dsp.exec_cmd("playerctl next"),
    { locked = true }
)

hl.bind(
    "XF86AudioPrev",
    hl.dsp.exec_cmd("playerctl previous"),
    { locked = true }
)

-- ============================================================
-- 11. SCREENSHOTS
-- ============================================================

-- Select area and copy to clipboard
hl.bind(
    "Print",
    hl.dsp.exec_cmd(
        "grim -g \"$(slurp)\" - | wl-copy --type image/png"
    )
)

-- Screenshot of focused monitor to clipboard
hl.bind(
    "SHIFT + Print",
    hl.dsp.exec_cmd(
        "grim -o \"$(hyprctl monitors -j | jq -r '.[] | select(.focused == true).name')\" - | wl-copy --type image/png"
    )
)

-- ============================================================
-- 12. LOCK SCREEN AND SESSION
-- ============================================================

-- Lock screen
hl.bind(
    mod .. " + L",
    hl.dsp.exec_cmd("pidof hyprlock >/dev/null || hyprlock")
)

-- Logout from regular Hyprland session
hl.bind(
    mod .. " + SHIFT + E",
    hl.dsp.exit()
)

-- ============================================================
-- END
-- ============================================================
