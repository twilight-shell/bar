import QtQuick
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import Twilight.Core

// Tray icons that hop under the pointer.
Row {
    id: root

    required property var barWindow

    spacing: 8

    Repeater {
        model: SystemTray.items

        delegate: MouseArea {
            id: item

            required property SystemTrayItem modelData

            width: 20
            height: 20
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
            cursorShape: Qt.PointingHandCursor

            onClicked: mouse => {
                if (mouse.button === Qt.MiddleButton) {
                    modelData.secondaryActivate();
                } else if (mouse.button === Qt.LeftButton && !modelData.onlyMenu) {
                    modelData.activate();
                } else if (modelData.hasMenu) {
                    const pos = mapToItem(null, 0, height);
                    modelData.display(root.barWindow, pos.x, pos.y + Theme.gap);
                }
            }

            onEntered: hop.restart()

            IconImage {
                id: icon

                anchors.fill: parent
                source: item.modelData.icon
                scale: item.containsMouse ? 1.2 : 1

                Behavior on scale {
                    NumberAnimation { duration: 250; easing.type: Easing.OutBack; easing.overshoot: 3 }
                }
            }

            SequentialAnimation {
                id: hop

                NumberAnimation { target: icon; property: "y"; to: -5; duration: 120; easing.type: Easing.OutQuad }
                NumberAnimation { target: icon; property: "y"; to: 0; duration: 380; easing.type: Easing.OutBounce }
            }
        }
    }
}
