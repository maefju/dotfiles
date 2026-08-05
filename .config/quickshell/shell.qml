//@ pragma UseQApplication

import Quickshell
import Quickshell.Io
import "WelcomeApp"
import "PowerApp"
import "SidebarApp"
import "CalendarApp"
import "WallpaperApp"
import "StatusbarApp"
import "CustomTheme"

ShellRoot {
    // Test IPC tools: qs ipc show

    IpcHandler {
        target: "theme-manager" 
        function reload(): void {
            Theme.reloadTheme()
        }
    }

    WelcomeWindow {}
    PowerWindow {}
    SidebarWindow {}
    CalendarWindow {}
    WallpaperWindow {}
    // One StatusbarWindow per connected screen, so the bar shows
    // simultaneously on every monitor. Shared state (settings, the
    // "statusbar" IpcHandler) lives in StatusbarState, not per instance.
    Variants {
        model: Quickshell.screens
        StatusbarWindow {}
    }
}