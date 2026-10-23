import QtQuick
import Quickshell
import Twilight.Core

// Time with digits that roll over one by one, a blinking colon, the date
// and a sun or moon for the time of day.
Row {
    id: root

    property bool h24: true
    property bool seconds: false
    // Digits only; colons go after the hours and minutes.
    readonly property string time: Qt.formatDateTime(clock.date, (h24 ? "HH" : "hh") + "mm" + (seconds ? "ss" : ""))
    readonly property int hour: clock.date.getHours()

    spacing: 10

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    Text {
        anchors.verticalCenter: parent.verticalCenter
        // nf-md-weather_night / weather_sunny
        text: String.fromCodePoint(root.hour >= 6 && root.hour < 20 ? 0xf0599 : 0xf0594)
        color: Theme.star
        font.family: Theme.font
        font.pixelSize: 16
        rotation: 12 * Ticker.wave(4.4)
    }

    Row {
        anchors.verticalCenter: parent.verticalCenter

        Repeater {
            model: root.time.length

            Row {
                required property int index

                RollText {
                    text: root.time[index]
                    color: Theme.text
                    pixelSize: 17
                    bold: true
                    outline: true
                }

                Text {
                    visible: index === 1 || index === 3 && index < root.time.length - 1
                    anchors.verticalCenter: parent.verticalCenter
                    text: ":"
                    color: Theme.star
                    font.family: Theme.font
                    font.pixelSize: 17
                    font.bold: true
                    opacity: clock.date.getSeconds() % 2 === 0 ? 1 : 0.25

                    Behavior on opacity {
                        NumberAnimation { duration: 250 }
                    }
                }
            }
        }
    }

    Text {
        anchors.verticalCenter: parent.verticalCenter
        visible: !root.h24
        text: Qt.formatDateTime(clock.date, "AP")
        color: Theme.star
        font.family: Theme.font
        font.pixelSize: 12
        font.bold: true
    }

    Text {
        anchors.verticalCenter: parent.verticalCenter
        text: Qt.formatDateTime(clock.date, "ddd d MMM")
        color: Theme.primary
        font.family: Theme.font
        font.pixelSize: 13
    }
}
