-- Work laptop (Intel iGPU + NVIDIA, hybrid)

BROWSER         = "chromium"

MONITOR1        = "DP-1"
MONITOR2        = "HDMI-A-1"
MONITOR3        = "eDP-1"
PRIMARY_MONITOR = MONITOR1

-- Main monitor — ASUS PG27UCDM
hl.monitor({ output = "DP-1", mode = "3840x2160@240", position = "0x0", scale = 1.666667, vrr = 2 })
-- Secondary monitor
hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "auto-right", scale = 1 })
-- Internal panel
hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto-right", scale = 1 })

hl.config({
    cursor = {
        no_hardware_cursors = true,
        use_cpu_buffer = 2,
    },
})

hl.on("hyprland.start", function()
    hl.exec_cmd("kanshi -c ~/.config/kanshi/config")
end)
