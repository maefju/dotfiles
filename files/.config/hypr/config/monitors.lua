-- Monitor wiki https://wiki.hypr.land/Configuring/Basics/Monitors/
-- Output names can be found with `hyprctl monitors`.
-- Machine-specific monitor rules live in config/hosts/<hostname>.lua.

-- Fallback for any other output (projectors, meeting-room screens, ...)
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1,
})
