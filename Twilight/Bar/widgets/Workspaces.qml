import QtQuick
import Twilight.Core
import Twilight.Compositor

// Workspaces as stars: ★ active, ✦ has windows, ✧ empty. A pink pill
// flows between them like liquid: its leading edge moves first and the
// trailing edge catches up.
Item {
    id: root

    required property string screenName

    readonly property var list: Compositor.workspaces.filter(ws => ws.output === screenName)
    readonly property int activeIndex: list.findIndex(ws => ws.active)
    readonly property int cell: 28
    readonly property int spacing: 4

    property real leftEdge: 0
    property real rightEdge: cell
    property bool movingRight: true

    implicitWidth: list.length * cell + Math.max(0, list.length - 1) * spacing
    implicitHeight: cell

    function place(animate) {
        if (activeIndex < 0)
            return;
        const left = activeIndex * (cell + spacing);
        movingRight = left >= leftEdge;
        if (!animate) {
            leftAnim.enabled = false;
            rightAnim.enabled = false;
        }
        leftEdge = left;
        rightEdge = left + cell;
        leftAnim.enabled = true;
        rightAnim.enabled = true;
    }

    onActiveIndexChanged: place(true)
    Component.onCompleted: place(false)

    Behavior on leftEdge {
        id: leftAnim
        NumberAnimation { duration: root.movingRight ? 420 : 200; easing.type: Easing.OutBack; easing.overshoot: 1.2 }
    }

    Behavior on rightEdge {
        id: rightAnim
        NumberAnimation { duration: root.movingRight ? 200 : 420; easing.type: Easing.OutBack; easing.overshoot: 1.2 }
    }

    Sticker {
        visible: root.activeIndex >= 0
        x: root.leftEdge
        width: root.rightEdge - root.leftEdge
        height: root.cell
        radius: root.cell / 2
        lift: 3
        fill: Theme.accent
    }

    Repeater {
        model: root.list

        delegate: Item {
            id: ws

            required property var modelData
            required property int index

            readonly property bool active: modelData.active

            x: index * (root.cell + root.spacing)
            width: root.cell
            height: root.cell

            Text {
                id: glyph

                anchors.centerIn: parent
                anchors.verticalCenterOffset: 1
                text: ws.active ? "★" : ws.modelData.hasWindows ? "✦" : "✧"
                color: ws.active ? Theme.text
                     : ws.modelData.urgent ? Theme.accent
                     : area.containsMouse ? Theme.star
                     : Theme.muted
                font.pixelSize: ws.active ? 17 : 14
                style: ws.active ? Text.Outline : Text.Normal
                styleColor: Theme.ink
                scale: area.containsMouse && !ws.active ? 1.3 : 1

                Behavior on color {
                    ColorAnimation { duration: Theme.animMs }
                }
                Behavior on scale {
                    NumberAnimation { duration: 250; easing.type: Easing.OutBack; easing.overshoot: 3 }
                }
            }

            // The star pops and twirls when its workspace becomes active.
            ParallelAnimation {
                id: pop

                RotationAnimation { target: glyph; from: -180; to: 0; duration: 650; easing.type: Easing.OutBack; easing.overshoot: 1.5 }
                NumberAnimation { target: glyph; property: "scale"; from: 0.3; to: 1; duration: 550; easing.type: Easing.OutBack; easing.overshoot: 3 }
            }

            onActiveChanged: if (active) pop.restart()

            MouseArea {
                id: area

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: Compositor.focusWorkspace(ws.modelData.idx)
            }
        }
    }

    WheelHandler {
        onWheel: event => event.angleDelta.y > 0 ? Compositor.workspaceUp() : Compositor.workspaceDown()
    }
}
