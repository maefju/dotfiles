package.path = package.path .. ";./?.lua;./?/init.lua"
local smw = require("plugins.split-monitor-workspaces")


-- Monitors in priority order, skipping ones a machine doesn't have
local monitors = {}
for _, m in ipairs({ PRIMARY_MONITOR, MONITOR2, MONITOR3 }) do
    if m and m ~= "" then table.insert(monitors, m) end
end

smw.setup({
    workspace_count = NUM_WPM, -- This will create NUM_WPM persistent workspaces on each monitor at startup
    monitor_priority = monitors, -- This is the order in which the monitors will be checked for workspaces. The first monitor in this list will be the one that gets the first workspace, and so on.
    keep_focused = true, -- Keep the currently focused workspace when the config is reloaded
})

--- `get_amount_of_workspaces` is an easy helper function that simply returns the workspace_count you passed to the setup function.
local mainMod = "SUPER"
for i = 1, smw.get_amount_of_workspaces() do
    local n = tostring(i)
    if n == "10" then n = "0" end -- Optional if you configured 10 workspaces: bind workspace 10 to SUPER + 0
    -- Switch to the Nth workspace on the currently focused monitor.
    hl.bind(mainMod .. " + " .. n, smw.workspace(n))
    -- Move the active window to the Nth workspace on the currently focused monitor silently (no focus change).
    hl.bind(mainMod .. " + SHIFT + " .. n, smw.move_to_workspace_silent(n))
end


hl.bind(mainMod .. " + SHIFT + G", smw.grab_rogue_windows())
for i, m in ipairs(monitors) do
    hl.bind(mainMod .. " + CTRL + " .. i, hl.dsp.focus({ monitor = m }))
end

