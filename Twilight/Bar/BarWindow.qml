import QtQuick
import Quickshell
import Twilight.Core
import "widgets"

// The bar on one screen.
PanelWindow {
    id: bar

    required property ShellScreen modelData

    property string activePopout: ""
    property bool hour24: true
    property bool seconds: false

    signal popoutRequested(string name)

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
}
