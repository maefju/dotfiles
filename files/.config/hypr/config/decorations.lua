-- Look and feel configuration

hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 5,
        border_size = 1,
        extend_border_grab_area = 10,
        resize_on_border = true,
        -- border/group colors are set by noctalia.lua (apply_theme)
    },
    decoration = {
        dim_special = 0.3,
        rounding = 2,
        active_opacity = 1,
        inactive_opacity = 0.90,
        fullscreen_opacity = 1,
        
        blur = {
            size = 5,
            passes = 4,
            special = true,
        },
    },
})
