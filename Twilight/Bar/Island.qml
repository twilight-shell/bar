import QtQuick
import QtQuick.Effects
import Twilight.Core

// One floating sticker of the bar. Drops in from above on startup after
// `delay` ms and springs to fit its content when that changes size.
// Under the pointer it floats up, tilts toward the cursor and a glint of
// light sweeps across it.
Item {
    id: root

    property int delay: 0
    property int padding: 10
    property color fill: Theme.surface
    // Clickable islands open something; `active` lights them while it's open.
    property bool clickable: false
    property bool active: false
    default property alias items: row.data

    signal clicked

    // 1 = above the screen, 0 = in place.
    property real drop: 1
    // 0 = resting, 1 = hovered; springs between the two.
    property real hover: hoverHandler.hovered ? 1 : 0
    // Tilt toward the pointer, gentler on wide islands.
    property real tilt: hoverHandler.hovered
        ? (hoverHandler.point.position.x / width - 0.5) * Math.min(4, 280 / width)
        : 0

    implicitWidth: row.implicitWidth + padding * 2
    implicitHeight: 40
    width: implicitWidth
    height: implicitHeight
    scale: 1 + hover * 0.04

    Behavior on width {
        NumberAnimation { duration: 340; easing.type: Easing.OutBack; easing.overshoot: 1.3 }
    }
    Behavior on hover {
        NumberAnimation { duration: 380; easing.type: Easing.OutBack; easing.overshoot: 2.2 }
    }
    Behavior on tilt {
        NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
    }

    transform: [
        Translate {
            y: -root.drop * 70 - root.hover * 3
        },
        Rotation {
            origin.x: root.width / 2
            origin.y: root.height / 2
            angle: root.tilt
        }
    ]

    HoverHandler {
        id: hoverHandler

        onHoveredChanged: if (hovered) glint.restart()
    }

    Component.onCompleted: dropIn.start()

    SequentialAnimation {
        id: dropIn

        PauseAnimation { duration: root.delay }
        NumberAnimation {
            target: root
            property: "drop"
            to: 0
            duration: 700
            easing.type: Easing.OutBack
            easing.overshoot: 1.8
        }
    }

    Sticker {
        id: sticker

        anchors.fill: parent
        radius: 14
        lift: Theme.lift + root.hover * 3
        fill: root.active ? Theme.surfaceHigh : root.fill
        edge: root.active ? Theme.star : Theme.ink
    }

    MouseArea {
        anchors.fill: parent
        enabled: root.clickable
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }

    // Glint: a slanted band of light swept across the sticker, masked to
    // its rounded shape.
    Item {
        id: glintLayer

        anchors.fill: parent
        visible: false
        layer.enabled: true

        Rectangle {
            id: band

            property real pos: -1

            x: band.pos * (root.width + width) - width
            y: -root.height
            width: 26
            height: root.height * 3
            rotation: 20
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0; color: Qt.rgba(1, 1, 1, 0) }
                GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, 0.22) }
                GradientStop { position: 1; color: Qt.rgba(1, 1, 1, 0) }
            }
        }
    }

    Rectangle {
        id: glintMask

        anchors.fill: parent
        anchors.margins: Theme.outline
        radius: 14 - Theme.outline
        visible: false
        layer.enabled: true
    }

    MultiEffect {
        anchors.fill: parent
        source: glintLayer
        maskEnabled: true
        maskSource: glintMask
        visible: glint.running
    }

    NumberAnimation {
        id: glint

        target: band
        property: "pos"
        from: 0
        to: 1
        duration: 650
        easing.type: Easing.InOutQuad
    }

    Row {
        id: row

        x: root.padding
        anchors.verticalCenter: parent.verticalCenter
        spacing: 10
    }
}
