-- ============================================================
-- Hyprland session startup
-- ============================================================

hl.on("hyprland.start", function()

    -- Export session variables for D-Bus/systemd services
    hl.exec_cmd(
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
    )

    -- Desktop components
    hl.exec_cmd("waybar")
    hl.exec_cmd("swaync")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("hyprpolkitagent")

end)