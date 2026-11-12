-- Gaming PC (NVIDIA)

BROWSER         = "firefox"

MONITOR1        = "DP-1"
MONITOR2        = "DP-2"
MONITOR3        = ""
PRIMARY_MONITOR = MONITOR1

-- Main monitor — ASUS PG27UCDM
hl.monitor({ output = "DP-1", mode = "3840x2160@240", position = "0x0", scale = 1.666667, vrr = 2 })
-- Secondary monitor
hl.monitor({ output = "DP-2", mode = "preferred", position = "auto-right", scale = 1 })

hl.config({
    cursor = {
        no_hardware_cursors = true,
        use_cpu_buffer = 2,
    },
})
