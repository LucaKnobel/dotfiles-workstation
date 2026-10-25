-- ============================================================
-- Workstation monitor configuration
-- ============================================================

-- Left portrait monitor
hl.monitor({
    output = "HDMI-A-1",
    mode = "2560x1440@59.951",
    position = "0x0",
    scale = 1.6,
    transform = 1,
})

-- Main 4K monitor
hl.monitor({
    output = "DP-1",
    mode = "3840x2160@59.997",
    position = "900x0",
    scale = 1.333333,
    transform = 0,
})

-- Right portrait monitor
hl.monitor({
    output = "HDMI-A-2",
    mode = "2560x1440@59.951",
    position = "3780x0",
    scale = 1.6,
    transform = 3,
})

-- Fallback for unknown monitors
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1,
})