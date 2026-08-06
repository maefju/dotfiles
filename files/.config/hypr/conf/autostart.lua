hl.on("hyprland.start", function()
    local HOME = os.getenv("HOME")

    -- Export variables to systemd
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    -- Restart portals so they catch the environment
    hl.exec_cmd("systemctl --user stop xdg-desktop-portal xdg-desktop-portal-hyprland")
    hl.exec_cmd("systemctl --user start xdg-desktop-portal-hyprland xdg-desktop-portal")


    -- Load cursor
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 24")


    -- Start polkit daemon (sudo pw prompt)
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

    -- Start swaync
    hl.exec_cmd("swaync")

    -- Start hypridle
    hl.exec_cmd("hypridle")

    -- Load cliphist history
    hl.exec_cmd("wl-paste --watch cliphist store")

    hl.exec_cmd("hyprpm reload -n")
    hl.exec_cmd("powerprofilesctl set performance")
    hl.exec_cmd("noctalia")
end)
