-- ============================================================
-- Keybindings
-- ============================================================

local mod = "SUPER"

-- Applications
hl.bind(mod .. " + Return", hl.dsp.exec_cmd("ghostty"))
hl.bind(mod .. " + D", hl.dsp.exec_cmd("hyprlauncher"))
hl.bind(mod .. " + E", hl.dsp.exec_cmd("nautilus"))
hl.bind(mod .. " + B", hl.dsp.exec_cmd("brave"))
hl.bind(mod .. " + C", hl.dsp.exec_cmd("code"))

-- Window management
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mod .. " + SPACE", hl.dsp.window.float())

-- Window focus
local directions = {
    LEFT = "l",
    RIGHT = "r",
    UP = "u",
    DOWN = "d",
}

for key, direction in pairs(directions) do
    hl.bind(
        mod .. " + " .. key,
        hl.dsp.focus({ direction = direction })
    )

    hl.bind(
        mod .. " + SHIFT + " .. key,
        hl.dsp.window.move({ direction = direction })
    )
end

-- Resize windows
hl.bind(
    mod .. " + CTRL + LEFT",
    hl.dsp.window.resize({
        x = -100, y = 0, relative = true
    }),
    { repeating = true }
)

hl.bind(
    mod .. " + CTRL + RIGHT",
    hl.dsp.window.resize({
        x = 100, y = 0, relative = true
    }),
    { repeating = true }
)

hl.bind(
    mod .. " + CTRL + UP",
    hl.dsp.window.resize({
        x = 0, y = -100, relative = true
    }),
    { repeating = true }
)

hl.bind(
    mod .. " + CTRL + DOWN",
    hl.dsp.window.resize({
        x = 0, y = 100, relative = true
    }),
    { repeating = true }
)

-- Move and resize with mouse
hl.bind(
    mod .. " + mouse:272",
    hl.dsp.window.drag(),
    { mouse = true }
)

hl.bind(
    mod .. " + mouse:273",
    hl.dsp.window.resize(),
    { mouse = true }
)

-- Dwindle controls
hl.bind(mod .. " + V", hl.dsp.layout("togglesplit"))
hl.bind(mod .. " + P", hl.dsp.window.pseudo())

-- Workspaces 1 to 10
for i = 1, 10 do
    local key = tostring(i % 10)

    hl.bind(
        mod .. " + " .. key,
        hl.dsp.focus({ workspace = i })
    )

    hl.bind(
        mod .. " + SHIFT + " .. key,
        hl.dsp.window.move({ workspace = i })
    )
end

-- Relative workspace navigation
hl.bind(
    mod .. " + ALT + UP",
    hl.dsp.focus({ workspace = "r+1" })
)

hl.bind(
    mod .. " + ALT + DOWN",
    hl.dsp.focus({ workspace = "r-1" })
)

-- Scratchpad
hl.bind(
    mod .. " + S",
    hl.dsp.workspace.toggle_special("magic")
)

hl.bind(
    mod .. " + SHIFT + S",
    hl.dsp.window.move({
        workspace = "special:magic"
    })
)

-- Audio
hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd(
        "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
    ),
    { repeating = true }
)

hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd(
        "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    ),
    { repeating = true }
)

hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd(
        "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    )
)

hl.bind(
    "XF86AudioMicMute",
    hl.dsp.exec_cmd(
        "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
    )
)

-- Screenshots
hl.bind(
    "Print",
    hl.dsp.exec_cmd(
        "grim -g \"$(slurp)\" - | wl-copy --type image/png"
    )
)

-- Lock screen
hl.bind(
    mod .. " + L",
    hl.dsp.exec_cmd("hyprlock")
)

-- Logout
hl.bind(
    mod .. " + SHIFT + E",
    hl.dsp.exit()
)