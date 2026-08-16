-- Monitor wiki https://wiki.hypr.land/Configuring/Basics/Monitors/
-- Example: output can be found with hyprctl monitors. Edit variables.lua for the monitor outputs instead of here directly
-- hl.monitor({
--     output    = "MONITOR1",
--     mode      = "1920x1080@60",
--     position  = "0x0",
--     scale     = "1",
-- })
-- Main monitor — ASUS PG27UCDM
hl.monitor({
    output = "DP-1",
    mode = "3840x2160@240",
    position = "0x0",
    scale = 1.666667,
    vrr = 2,
})

-- Secondary monitor
hl.monitor({
    output = "HDMI-A-1",
    mode = "preferred",
    position = "auto-right",
    scale = 1,
})