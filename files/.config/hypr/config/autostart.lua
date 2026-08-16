-- Auto-start config
-- if you dont use UWSM add your auto start programs here, otherwise use XDG autostart https://wiki.archlinux.org/title/XDG_Autostart

-- hl.on("hyprland.start", function()
--     hl.exec_cmd("dbus-update-activation-environment --systemd --all")
--     hl.exec_cmd("noctalia")
--     hl.exec_cmd("xhost +SI:localuser:root")
-- end)


hl.on("hyprland.start", function()
    -- if we get screensharing issues:
    -- hl.exec_cmd("~/.config/hypr/scripts/xdg.sh")

    hl.exec_cmd("kanshi -c ~/.config/kanshi/config")
end)