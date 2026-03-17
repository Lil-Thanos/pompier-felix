import QtQuick
import QtQuick.Layouts

Rectangle {
    id: badge

    property bool enService: true

    width: 120
    height: 36
    radius: 18

    color: enService ? "#059669" : "#7f1d1d"

    RowLayout {
        anchors.centerIn: parent
        spacing: 6

        Rectangle {
            width: 8
            height: 8
            radius: 4
            color: enService ? "#d1fae5" : "#fecaca"

            SequentialAnimation on opacity {
                running: true
                loops: Animation.Infinite
                NumberAnimation { from: 1; to: 0.3; duration: 800 }
                NumberAnimation { from: 0.3; to: 1; duration: 800 }
            }
        }

        Text {
            text: enService ? "En service" : "Hors service"
            color: "white"
            font.pixelSize: 13
            font.bold: true
        }

    }
}
