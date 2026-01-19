import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Effects


Rectangle {
    id: root
    property string title: "Card Title"
    property color headerColor: "#f97316"
    default property alias cardContent: contentContainer.children

    radius: 16
    color: "white"
    border.color: "#e5e7eb"
    border.width: 1

    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowVerticalOffset: 4
        shadowColor: "#15000000"
        shadowBlur: 0.4
    }


    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Header
        Rectangle {
            height: 56
            color: headerColor
            Layout.fillWidth: true
            radius: 16

            // Bottom corners not rounded
            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 16
                color: parent.color
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16

                Text {
                    text: title
                    color: "white"
                    font.pixelSize: 16
                    font.bold: true
                }

                Item { Layout.fillWidth: true }

                Rectangle {
                    width: 24
                    height: 24
                    radius: 12
                    color: Qt.rgba(1, 1, 1, 0.2)

                    Text {
                        anchors.centerIn: parent
                        text: "ℹ"
                        color: "white"
                        font.pixelSize: 14
                    }
                }
            }
        }

        // Content
        Item {
            id: contentContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
