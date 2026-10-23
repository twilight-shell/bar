import QtQuick
import Quickshell
import Twilight.Core

// The bar: a row of floating islands along the top of every screen.
//
// It doesn't know the other components. What is open elsewhere comes in as
// properties and what the user asks for goes out as signals, for the host to
// connect.
Scope {
    id: root

    // The card dropped from the bar that is open: "", "calendar" or "sound".
    property string activePopout: ""
    // Whether the launcher is open; the launcher button stays lit.
    property bool launcherOpen: false

    signal popoutRequested(string name)
    // Left click on the launcher button, and right click: the settings.
    signal launcherRequested
    signal settingsRequested

    // Settings, in bar.toml.
    readonly property bool windowTitle: config.get("window-title", true)
    readonly property bool hour24: config.get("clock.hour24", true)
    readonly property bool seconds: config.get("clock.seconds", false)

    ConfigFile {
        id: config

        name: "bar"
    }

    Variants {
        model: Quickshell.screens

        BarWindow {
            activePopout: root.activePopout
            launcherOpen: root.launcherOpen
            windowTitle: root.windowTitle
            hour24: root.hour24
            seconds: root.seconds

            onPopoutRequested: name => root.popoutRequested(name)
            onLauncherRequested: root.launcherRequested()
            onSettingsRequested: root.settingsRequested()
        }
    }
}
