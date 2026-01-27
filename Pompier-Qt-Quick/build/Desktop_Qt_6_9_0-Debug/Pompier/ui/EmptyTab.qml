import QtQuick 2.15
import QtQuick.Layouts 1.15


Rectangle {
    id: root
    color: "white"
    radius: 16

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 20

        // Header
        Rectangle {
            height: 64
            color: "#10b981"
            Layout.fillWidth: true
            radius: 16

            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 16
                color: parent.color
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 24
                anchors.rightMargin: 24

                Text {
                    text: "👥 Gestion des Renforts                                                                                                                                                                                                                                                                                       (DEMO)"
                    font.pixelSize: 20
                    font.bold: true
                    color: "white"
                }

                Item { Layout.fillWidth: true }
            }
        }

        // Empty state
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 20

                Text {
                    text: "🔧"
                    font.pixelSize: 80
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    text: "Cette page est en cours de développement"
                    font.pixelSize: 20
                    font.bold: true
                    color: "#374151"
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    text: "La gestion des renforts sera disponible prochainement"
                    font.pixelSize: 15
                    color: "#6b7280"
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
}
