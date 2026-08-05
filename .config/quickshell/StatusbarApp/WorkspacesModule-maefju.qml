import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import qs.CustomTheme

// Hyprland workspace switcher.
RowLayout {
    id: wsRoot
    spacing: 6

    // Retained for compatibility with StatusbarWindow's settings binding, but
    // no longer used: only workspaces that actually hold windows are shown,
    // so there is no fixed minimum dot count anymore.
    property int minWorkspaces: 5

    // The individual workspace buttons, exposed so StatusbarWindow can splice
    // them into its keyboard-navigation list. Rebuilt whenever workspaces are
    // added or removed.
    property var navButtons: []

    // The monitor this module instance is displayed on, derived from its own
    // containing window (via the QsWindow attached property) rather than
    // whichever monitor currently has Hyprland's focus. This is what lets two
    // instances - one per StatusbarWindow on each monitor - each show only
    // their own monitor's workspaces (split-monitor-workspaces gives each
    // monitor its own contiguous workspace id range).
    readonly property var ownScreen: QsWindow.window ? QsWindow.window.screen : null
    readonly property HyprlandMonitor activeMonitor: wsRoot.ownScreen ? Hyprland.monitorFor(wsRoot.ownScreen) : null

    function rebuildNavButtons(): void {
        let a = []
        for (let i = 0; i < rep.count; i++)
            a.push(rep.itemAt(i))
        wsRoot.navButtons = a
    }

    // Only the workspaces that live on activeMonitor and currently hold at
    // least one window. lastIpcObject.windows isn't reactive on its own, so
    // WorkspaceRefresher (shared across all WorkspacesModule instances, see
    // WorkspaceRefresher.qml) refreshes it on window/workspace events.
    readonly property var workspaceRefresher: WorkspaceRefresher

    readonly property var monitorWorkspaces: {
        const list = Hyprland.workspaces.values
        let mine = []
        for (let i = 0; i < list.length; i++)
            if (wsRoot.activeMonitor && list[i].monitor && list[i].monitor.id === wsRoot.activeMonitor.id
                    && list[i].lastIpcObject && list[i].lastIpcObject.windows > 0)
                mine.push(list[i])
        return mine
    }

    // The workspace ids to render: just the ids of monitorWorkspaces, in order.
    readonly property var workspaceIds: wsRoot.monitorWorkspaces.map(w => w.id)

    // The live Hyprland workspace for an id on the active monitor, or null.
    function workspaceById(id: int): var {
        const mine = wsRoot.monitorWorkspaces
        for (let i = 0; i < mine.length; i++)
            if (mine[i].id === id)
                return mine[i]
        return null
    }

    Repeater {
        id: rep
        model: wsRoot.workspaceIds

        onItemAdded: wsRoot.rebuildNavButtons()
        onItemRemoved: wsRoot.rebuildNavButtons()

        delegate: Rectangle {
            id: ws
            required property var modelData   // the workspace id (int)
            // Set by StatusbarWindow's keyboard navigation.
            property bool focused: false

            // Whether this workspace is the currently focused one.
            readonly property bool isActive: wsRoot.activeMonitor
                && wsRoot.activeMonitor.activeWorkspace
                && wsRoot.activeMonitor.activeWorkspace.id === ws.modelData

            // Run this workspace's action (mouse click or keyboard Return).
            // Hyprland with Lua dispatchers ignores the plain "workspace N"
            // string, so branch on usingLua the same way the overview does.
            function activate(): void {
                if (Hyprland.usingLua)
                    Hyprland.dispatch("hl.dsp.focus({workspace = '" + ws.modelData + "'})")
                else
                    Hyprland.dispatch("workspace " + ws.modelData)
            }

            implicitWidth: 26
            implicitHeight: 26
            radius: 13

            color: ws.isActive
                ? Theme.primary
                : (wsMouse.containsMouse ? Theme.surface_container_high : "transparent")
            border.color: Theme.primary
            border.width: ws.isActive ? 0 : 1

            // Crossfade the fill between active / hover / inactive states so the
            // background of the active circle fades in and the previous one out.
            Behavior on color {
                ColorAnimation { duration: 500; easing.type: Easing.OutQuint }
            }
            // Fade the outline in/out as the fill takes over on activation.
            Behavior on border.width {
                NumberAnimation { duration: 500; easing.type: Easing.OutQuint }
            }

            // Keyboard-selection ring, distinct from the active-workspace fill.
            Rectangle {
                anchors.fill: parent
                anchors.margins: -3
                radius: width / 2
                color: "transparent"
                border.color: Theme.primary
                border.width: 2
                opacity: ws.focused ? 1 : 0
                Behavior on opacity {
                    NumberAnimation { duration: 150 }
                }
            }

            Text {
                anchors.centerIn: parent
                text: ws.modelData
                color: ws.isActive ? Theme.background : Theme.on_background
                font.family: Theme.fontFamily
                font.pixelSize: 13
                font.bold: true

                // Match the fill crossfade so the label recolors in step.
                Behavior on color {
                    ColorAnimation { duration: 500; easing.type: Easing.OutQuint }
                }
            }

            MouseArea {
                id: wsMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: ws.activate()
            }
        }
    }
}
