-- ============================================================
-- Hyprland 0.56 | Arch Linux
-- Main configuration
-- Managed by chezmoi
-- ============================================================

-- Modules
require("monitors")
require("keybinds")
require("autostart")

-- General configuration
hl.config({
    input = {
        kb_layout = "ch",
        kb_variant = "de",
        follow_mouse = 1,
        sensitivity = 0,

        touchpad = {
            natural_scroll = false,
        },
    },

    general = {
    gaps_in = 5,
    gaps_out = 10,
    border_size = 3,
    layout = "dwindle",
    resize_on_border = true,

    col = {
        active_border = "rgba(ffffffff)",
        inactive_border = "rgba(595959aa)",
        },
    },

    decoration = {
        rounding = 10,
        active_opacity = 1.0,
        inactive_opacity = 0.98,

        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },

        blur = {
            enabled = true,
            size = 3,
            passes = 1,
        },
    },

    animations = {
        enabled = true,
    },

    misc = {
        disable_hyprland_logo = true,
        force_default_wallpaper = 0,
    },
})