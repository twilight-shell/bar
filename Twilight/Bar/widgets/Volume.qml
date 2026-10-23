import QtQuick
import Quickshell.Services.Pipewire
import Twilight.Core

// Volume pill with a little meter. Click opens the sound mixer, middle or
// right click toggles mute, scroll changes volume; the icon bounces on
// change and shakes when muted.
Tap {
    id: root

    // The mixer was asked for: a click on the pill.
    signal mixerRequested

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property real volume: sink?.audio?.volume ?? 0

    implicitWidth: content.implicitWidth + 20
    implicitHeight: 28
    visible: sink !== null
    fill: Theme.surfaceHigh

    onClicked: mouse => {
        if (mouse.button === Qt.LeftButton)
            root.mixerRequested();
        else
            root.sink.audio.muted = !root.muted;
    }
    onWheel: event => {
        const step = event.angleDelta.y > 0 ? 0.05 : -0.05;
        root.sink.audio.volume = Math.max(0, Math.min(1, root.volume + step));
    }

    onVolumeChanged: bounce.restart()
    onMutedChanged: if (muted) shake.restart()

    PwObjectTracker {
        objects: [root.sink]
    }

    Row {
        id: content

        anchors.centerIn: parent
        spacing: 7

        Text {
            id: icon

            anchors.verticalCenter: parent.verticalCenter
            // nf-md-volume_off / volume_low / volume_medium / volume_high
            text: String.fromCodePoint(root.muted ? 0xf0581
                : root.volume < 0.34 ? 0xf057f
                : root.volume < 0.67 ? 0xf0580
                : 0xf057e)
            color: root.muted ? Theme.muted : Theme.star
            font.family: Theme.font
            font.pixelSize: 15

            NumberAnimation {
                id: bounce

                target: icon
                property: "scale"
                from: 1.5
                to: 1
                duration: 350
                easing.type: Easing.OutBack
                easing.overshoot: 3
            }

            SequentialAnimation {
                id: shake

                NumberAnimation { target: icon; property: "rotation"; to: -18; duration: 60 }
                NumberAnimation { target: icon; property: "rotation"; to: 18; duration: 90 }
                NumberAnimation { target: icon; property: "rotation"; to: -10; duration: 80 }
                NumberAnimation { target: icon; property: "rotation"; to: 0; duration: 180; easing.type: Easing.OutBack }
            }
        }

        // Meter
        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: 46
            height: 8
            radius: 4
            color: Theme.bg
            border.color: Theme.ink
            border.width: 1

            Rectangle {
                x: 1
                y: 1
                height: parent.height - 2
                width: Math.max(height, (parent.width - 2) * root.volume)
                radius: height / 2
                visible: root.volume > 0
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0; color: root.muted ? Theme.muted : Theme.primary }
                    GradientStop { position: 1; color: root.muted ? Theme.muted : Theme.star }
                }

                Behavior on width {
                    NumberAnimation { duration: 280; easing.type: Easing.OutBack; easing.overshoot: 1.5 }
                }
            }
        }

        RollText {
            anchors.verticalCenter: parent.verticalCenter
            text: Math.round(root.volume * 100)
            color: root.muted ? Theme.muted : Theme.text
            pixelSize: 12
            duration: 260
        }
    }
}
