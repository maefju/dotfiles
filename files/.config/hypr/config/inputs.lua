-- Input configuration

hl.config({
    input = {
        kb_layout     = "de",
        kb_variant    = "nodeadkeys",
        kb_model      = "",
        kb_options    = "",
        kb_rules      = "",

        follow_mouse  = 1,

        sensitivity   = -0.775, -- -1.0 - 1.0, 0 means no modification.
        accel_profile = "flat",
        touchpad      = {
            natural_scroll = true,
        },
    },
})

hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "down", action = "close" })
hl.gesture({ fingers = 3, direction = "up", action = "fullscreen" })
hl.gesture({ fingers = 3, direction = "left", action = "float" })
