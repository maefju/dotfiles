package.path = package.path .. ";./?.lua;./?/init.lua"
local smw = require("plugins.split-monitor-workspaces")


smw.setup({
    workspace_count = 5, -- This will create 5 persistent workspaces on each monitor at startup
    monitor_priority = { PRIMARY_MONITOR, MONITOR2, MONITOR3 }, -- This is the order in which the monitors will be checked for workspaces. The first monitor in this list will be the one that gets the first workspace, and so on.
    keep_focused = true, -- Keep the currently focused workspace when the config is reloaded
})

--- `get_amount_of_workspaces` is an easy helper function that simply returns the workspace_count you passed to the setup function.
local mainMod = "SUPER"
for i = 1, smw.get_amount_of_workspaces() do
    local n = tostring(i)
    if n == "10" then n = "0" end -- Optional if you configured 10 workspaces: bind workspace 10 to SUPER + 0
    -- Switch to the Nth workspace on the currently focused monitor.
    hl.bind(mainMod .. " +" .. n, smw.workspace(n))
    -- Move the active window to the Nth workspace on the currently focused monitor silently (no focus change).
    hl.bind(mainMod .. " + SHIFT +" .. n, smw.move_to_workspace_silent(n))
end


hl.bind(mainMod .. " + SHIFT + G", smw.grab_rogue_windows())
hl.bind(mainMod .. " + CTRL + 1", hl.dsp.focus({ monitor = PRIMARY_MONITOR }))
hl.bind(mainMod .. " + CTRL + 2", hl.dsp.focus({ monitor = MONITOR2 }))
hl.bind(mainMod .. " + CTRL + 3", hl.dsp.focus({ monitor = MONITOR3 }))

