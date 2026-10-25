
-- ============================================================
-- Hyprland | Session autostart
-- ============================================================

hl.on("hyprland.start", function()

    -- Session environment for D-Bus and systemd
    hl.exec_cmd(
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
    )

    -- Desktop shell
    hl.exec_cmd("waybar")
    hl.exec_cmd("swaync")
    hl.exec_cmd("hyprpaper")

    -- Authentication dialogs
    hl.exec_cmd("systemctl --user start hyprpolkitagent.service")

    -- Night Light
    hl.exec_cmd("hyprsunset")

    -- Automatic screen locking
    -- hl.exec_cmd("hypridle")

end)
