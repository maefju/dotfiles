pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland

// Shared, debounced trigger for Hyprland.refreshWorkspaces().
//
// HyprlandWorkspace.lastIpcObject.windows (used by WorkspacesModule to know
// which workspaces currently hold windows) is only populated when a
// workspace is (re)fetched, so something needs to ask Hyprland to refetch on
// window/workspace lifecycle events. This is centralized in one singleton
// (rather than each WorkspacesModule instance listening independently) so
// that N per-monitor bars share a single event listener and a single
// debounced refresh - otherwise every relevant Hyprland event would trigger
// N redundant hyprctl round-trips, one per monitor's bar.
Singleton {
    id: root

    readonly property int debounceMs: 100

    Connections {
        target: Hyprland
        function onRawEvent(event: var): void {
            const name = event.name
            if (name === "openwindow" || name === "closewindow" || name === "movewindow"
                    || name === "movewindowv2" || name === "workspace")
                debounceTimer.restart()
        }
    }

    Timer {
        id: debounceTimer
        interval: root.debounceMs
        onTriggered: Hyprland.refreshWorkspaces()
    }
}
