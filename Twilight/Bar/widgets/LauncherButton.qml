import QtQuick
import Twilight.Core

// Twilight's cutie mark as a button: click opens the launcher, right-click
// the settings. The star breathes when idle, spins up under the pointer and
// stays lit while the launcher is open.
Tap {
    id: root

    // Whether the launcher is open, which keeps the star lit.
    property bool launcherOpen: false

    signal launcherRequested
    signal settingsRequested

    implicitWidth: 30
    implicitHeight: 30
    fill: root.launcherOpen ? Theme.primary : Theme.secondary
    hoverFill: Theme.primary
    onClicked: mouse => {
        if (mouse.button === Qt.RightButton)
            root.settingsRequested();
        else
            root.launcherRequested();
    }

    property real spin: 0

    states: State {
        when: root.hovered || root.launcherOpen
        PropertyChanges { root.spin: 144 }
    }

    transitions: Transition {
        NumberAnimation { property: "spin"; duration: 600; easing.type: Easing.OutBack; easing.overshoot: 2.5 }
    }

    Text {
        id: star

        anchors.centerIn: parent
        anchors.verticalCenterOffset: 1
        text: "★"
        color: Theme.star
        font.pixelSize: 18
        style: Text.Outline
        styleColor: Theme.ink
        rotation: root.spin
        // Breathes while idle.
        scale: root.hovered ? 1 : 1.035 + 0.115 * Ticker.wave(2.8)
    }

    // Two tiny sparkles orbiting the star while hovered.
    Repeater {
        model: 2

        Text {
            required property int index

            property real angle: index * 180

            x: root.width / 2 - width / 2 + Math.cos(angle * Math.PI / 180) * 13
            y: root.height / 2 - height / 2 + Math.sin(angle * Math.PI / 180) * 13
            text: "✦"
            color: Theme.text
            font.pixelSize: 8
            opacity: root.hovered ? 1 : 0

            Behavior on opacity {
                NumberAnimation { duration: 200 }
            }

            NumberAnimation on angle {
                running: root.hovered
                loops: Animation.Infinite
                from: index * 180
                to: index * 180 + 360
                duration: 1600
            }
        }
    }
}
