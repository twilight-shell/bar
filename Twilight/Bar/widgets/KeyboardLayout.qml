import QtQuick
import Twilight.Core
import Twilight.Compositor

// Current layout as a pill that flips over like a card when it switches.
Tap {
    id: root

    implicitWidth: 38
    implicitHeight: 28
    fill: Compositor.layoutIdx === 0 ? Theme.secondary : Theme.accent
    onClicked: Compositor.nextLayout()

    property real flip: 0

    Connections {
        target: Compositor

        function onLayoutIdxChanged() {
            flipAnim.restart();
        }
    }

    NumberAnimation {
        id: flipAnim

        target: root
        property: "flip"
        from: 180
        to: 0
        duration: 600
        easing.type: Easing.OutBack
        easing.overshoot: 1.8
    }

    Text {
        anchors.centerIn: parent
        text: Compositor.layout
        color: Theme.text
        font.family: Theme.font
        font.pixelSize: 13
        font.bold: true
        style: Text.Outline
        styleColor: Theme.ink

        transform: Rotation {
            origin.x: 0
            origin.y: 8
            axis { x: 1; y: 0; z: 0 }
            angle: root.flip
        }
    }
}
