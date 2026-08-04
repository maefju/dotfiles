#!/bin/bash
# -----------------------------------------------------
# Keyboard Variant Switcher
# Switches kb_variant based on the focused window.
# Managed by user — safe to keep across ml4w updates.
# -----------------------------------------------------

# Default variant (empty = standard de layout with dead keys)
DEFAULT_VARIANT=""

# Variant to use when a game is focused
GAME_VARIANT="nodeadkeys"

# Window classes that should use GAME_VARIANT
# Verify with: hyprctl activewindow | grep class
GAME_CLASSES=("cs2" "dota2" "deadlock", "farever")

CURRENT_VARIANT="$DEFAULT_VARIANT"

apply_variant() {
    local variant="$1"
    if [ "$variant" != "$CURRENT_VARIANT" ]; then
        hyprctl keyword input:kb_variant "$variant" -q
        CURRENT_VARIANT="$variant"
    fi
}

is_game_class() {
    local class="$1"
    for game in "${GAME_CLASSES[@]}"; do
        if [ "$class" = "$game" ]; then
            return 0
        fi
    done
    return 1
}

handle() {
    local event="$1"
    local prefix="activewindow>>"
    if [[ "$event" == "${prefix}"* ]]; then
        local class="${event#${prefix}}"
        class="${class%%,*}"
        if is_game_class "$class"; then
            apply_variant "$GAME_VARIANT"
        else
            apply_variant "$DEFAULT_VARIANT"
        fi
    fi
}

# Wait for Hyprland socket to be available
while [ ! -S "$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" ]; do
    sleep 0.5
done

socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" \
    | while IFS= read -r line; do handle "$line"; done
