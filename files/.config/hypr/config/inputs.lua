-- Input configuration

hl.config({
    input = {
        kb_layout     = "de",
        kb_variant    = "nodeadkeys",
        kb_model      = "",
        kb_options    = "",
        kb_rules      = "",

        follow_mouse  = 1,      -- 0 = none, 1 = focus, 2 = focus + follow

        sensitivity   = -0.775, -- -1.0 - 1.0, 0 means no modification.
        accel_profile = "flat",
        touchpad      = {
            natural_scroll = true,
        },
    },
    cursor = {
        no_hardware_cursors = true,
        use_cpu_buffer = 2
    }
})

hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "down", action = "close" })
hl.gesture({ fingers = 3, direction = "up", action = "fullscreen" })
hl.gesture({ fingers = 3, direction = "left", action = "float" })
