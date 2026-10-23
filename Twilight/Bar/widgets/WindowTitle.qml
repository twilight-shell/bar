import QtQuick
import Quickshell
import Quickshell.Widgets
import Twilight.Core
import Twilight.Compositor

// Focused window: app icon and title. The title rolls over only when focus
// moves to another window; title updates within the same window (terminals
// spinning a progress glyph, for one) are applied in place.
Row {
    id: root

    property int maxWidth: 400

    readonly property var window: Compositor.focusedWindow
    readonly property var entry: window ? DesktopEntries.heuristicLookup(window.appId) : null

    property int shownId: -2

    spacing: 8

    function sync() {
        const id = window?.id ?? -1;
        title.animate = id !== shownId;
        shownId = id;
        title.text = window ? window.title : "empty sky";
    }

    onWindowChanged: sync()
    Component.onCompleted: sync()

    Item {
        width: 20
        height: 20
        anchors.verticalCenter: parent.verticalCenter

        IconImage {
            id: icon

            anchors.fill: parent
            visible: root.window !== null && source != ""
            source: root.window ? Icons.find([root.entry?.icon, root.window.appId]) : ""

            // Bounce the icon in whenever the focused app changes.
            onSourceChanged: bounce.restart()

            NumberAnimation {
                id: bounce

                target: icon
                property: "scale"
                from: 0.2
                to: 1
                duration: 500
                easing.type: Easing.OutBack
                easing.overshoot: 3
            }
        }

        Text {
            anchors.centerIn: parent
            visible: !icon.visible
            text: root.window ? "★" : "✧"
            color: Theme.primary
            font.pixelSize: 16
        }
    }

    RollText {
        id: title

        anchors.verticalCenter: parent.verticalCenter
        maxWidth: root.maxWidth
        width: implicitWidth
        elide: Text.ElideRight
        color: root.window ? Theme.text : Theme.muted
        pixelSize: 13
    }
}
