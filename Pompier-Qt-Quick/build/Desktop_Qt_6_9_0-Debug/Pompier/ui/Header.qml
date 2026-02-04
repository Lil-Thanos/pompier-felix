import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Effects


Rectangle {
    height: 72
    color: "#dc2626"
    Layout.fillWidth: true

    // Ombre avec Qt 6
    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowVerticalOffset: 2
        shadowColor: "#40000000"
        shadowBlur: 0.4
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 24
        anchors.rightMargin: 24
        spacing: 20

        // Logo/Icon
        Rectangle {
            width: 48
            height: 48
            radius: 24
            color: "#ffffff"
            visible: false

            Text {
                anchors.centerIn: parent
                text: "🚒"
                font.pixelSize: 28
            }
        }

        // Title
        ColumnLayout {
            spacing: 2

            Text {
                text: "Gestion d'Intervention"
                font.pixelSize: 24
                font.bold: true
                color: "white"
            }

            Text {
                text: "Centre de Secours Principal"
                font.pixelSize: 13
                color: "#fecaca"
            }
        }

        Item { Layout.fillWidth: true }

        // Status Badge
        StatusBadge {
            id: badgeStatut
            Layout.alignment: Qt.AlignVCenter
        }

        // Time Display
        Rectangle {
            width: 100
            height: 36
            Layout.alignment: Qt.AlignVCenter
            radius: 6
            color: "#7f1d1d"

            Text {
                id: timeDisplay
                anchors.centerIn: parent
                text: Qt.formatTime(new Date(), "HH:mm:ss")
                color: "white"
                font.pixelSize: 14
                font.bold: true

                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: timeDisplay.text = Qt.formatTime(new Date(), "HH:mm:ss")
                }
            }
        }

        // Icons
        RowLayout {
            spacing: 12
            visible: false

            Button {
                width: 40
                height: 40

                background: Rectangle {
                    radius: 20
                    color: parent.hovered ? "#991b1b" : "transparent"
                    visible: false

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }
                }

                contentItem: Image {
                    source: "icons/help.svg"
                    width: 22
                    height: 22
                    fillMode: Image.PreserveAspectFit
                }
            }

            Button {
                width: 40
                height: 40
                visible: false

                background: Rectangle {
                    radius: 20
                    color: parent.hovered ? "#991b1b" : "transparent"
                    visible: false

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }
                }

                contentItem: Image {
                    source: "icons/menu.svg"
                    width: 22
                    height: 22
                    fillMode: Image.PreserveAspectFit
                }
            }
        }
    }
}
