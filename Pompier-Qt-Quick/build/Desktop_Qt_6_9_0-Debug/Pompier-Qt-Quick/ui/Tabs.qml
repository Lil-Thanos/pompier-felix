import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    height: 64
    color: "transparent"
    Layout.fillWidth: true

    property string activeTab
    signal tabChanged(string tab)

    RowLayout {
        anchors.fill: parent
        spacing: 8

        Repeater {
            model: [
                { label: "Nouvelle Intervention", value: "nouvelle", icon: "➕" },
                { label: "Alerte & Moyens", value: "alerte", icon: "🚨" },
                { label: "Gestion des Renforts", value: "gestion", icon: "👥" }
            ]

            delegate: Button {
                id: tabButton
                Layout.fillWidth: true
                height: 48

                property bool isActive: root.activeTab === modelData.value

                background: Rectangle {
                    radius: 10
                    color: tabButton.isActive ? "#dc2626" : "#ffffff"
                    border.color: tabButton.isActive ? "#dc2626" : "#e5e7eb"
                    border.width: 2

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }

                    // Effet hover
                    Rectangle {
                        anchors.fill: parent
                        radius: parent.radius
                        color: tabButton.hovered && !tabButton.isActive ? "#f3f4f6" : "transparent"

                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }
                    }
                }

                contentItem: RowLayout {
                    spacing: 8

                    Text {
                        text: modelData.icon
                        font.pixelSize: 20
                    }

                    Text {
                        text: modelData.label
                        font.pixelSize: 15
                        font.bold: tabButton.isActive
                        color: tabButton.isActive ? "white" : "#374151"
                        Layout.alignment: Qt.AlignVCenter
                    }

                    // Badge (exemple pour notifications)
                    Rectangle {
                        visible: modelData.value === "alerte"
                        width: 24
                        height: 24
                        radius: 12
                        color: tabButton.isActive ? "#fee2e2" : "#dc2626"

                        Text {
                            anchors.centerIn: parent
                            text: "3"
                            font.pixelSize: 11
                            font.bold: true
                            color: tabButton.isActive ? "#dc2626" : "white"
                        }
                    }
                }

                onClicked: root.tabChanged(modelData.value)
            }
        }

        Item { Layout.fillWidth: true }
    }
}
