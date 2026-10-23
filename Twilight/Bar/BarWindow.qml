import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Twilight.Core
import "widgets"

// The bar on one screen.
PanelWindow {
    id: bar

    required property ShellScreen modelData

    property string activePopout: ""
    property bool launcherOpen: false
    property var extras: []
    property bool windowTitle: true
    property bool hour24: true
    property bool seconds: false

    signal popoutRequested(string name)
    signal launcherRequested
    signal settingsRequested

    // An island for each extra that asked for this side.
    component Extras: Repeater {
        id: extras

        required property string slot
        // Where the islands' drop-in delays start, after the ones around them.
        required property int delay

        model: bar.extras.filter(e => e.component && (e.slot ?? "right") === slot)

        Island {
            required property var modelData
            required property int index

            delay: extras.delay + index * 60
            padding: 6

            Loader {
                anchors.verticalCenter: parent.verticalCenter
                sourceComponent: modelData.component
            }
        }
    }

    screen: modelData
    color: "transparent"
    // Headroom above the islands so they can float up on hover, and room
    // below for their shadow.
    readonly property int headroom: 5

    implicitHeight: headroom + 40 + Theme.lift + 5

    anchors {
        top: true
        left: true
        right: true
    }

    margins {
        top: Theme.gap - bar.headroom
        left: Theme.gap * 2
        right: Theme.gap * 2
    }

    Row {
        anchors.left: parent.left
        y: bar.headroom
        spacing: Theme.gap * 1.25

        Island {
            delay: 0
            padding: 5

            LauncherButton {
                anchors.verticalCenter: parent.verticalCenter
                launcherOpen: bar.launcherOpen
                onLauncherRequested: bar.launcherRequested()
                onSettingsRequested: bar.settingsRequested()
            }
        }

        Island {
            delay: 60
            padding: 6

            Workspaces {
                anchors.verticalCenter: parent.verticalCenter
                screenName: bar.screen.name
            }
        }

        Island {
            delay: 120
            visible: bar.windowTitle

            WindowTitle {
                anchors.verticalCenter: parent.verticalCenter
                maxWidth: bar.width * 0.22
            }
        }

        Extras {
            slot: "left"
            delay: 180
        }
    }

    Island {
        anchors.horizontalCenter: parent.horizontalCenter
        y: bar.headroom
        delay: 160
        clickable: true
        active: bar.activePopout === "calendar"
        onClicked: bar.popoutRequested("calendar")

        Clock {
            anchors.verticalCenter: parent.verticalCenter
            h24: bar.hour24
            seconds: bar.seconds
        }
    }

    Row {
        anchors.right: parent.right
        y: bar.headroom
        spacing: Theme.gap * 1.25

        Extras {
            slot: "right"
            delay: 140
        }

        Island {
            delay: 200
            padding: 6

            KeyboardLayout {
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Island {
            delay: 260
            visible: SystemTray.items.values.length > 0

            Tray {
                anchors.verticalCenter: parent.verticalCenter
                barWindow: bar
            }
        }

        Island {
            delay: 320
            padding: 6
            active: bar.activePopout === "sound"

            Volume {
                anchors.verticalCenter: parent.verticalCenter
                onMixerRequested: bar.popoutRequested("sound")
            }
        }
    }
}
