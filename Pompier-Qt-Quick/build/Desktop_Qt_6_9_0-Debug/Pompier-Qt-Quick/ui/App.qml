import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: appWindow
    width: 1920
    height: 1080
    visible: true
    title: "Gestion d'Intervention"
    color: "#f3f4f6"

    property string activeTab: "nouvelle"

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // --- Header ---
        Header {
            Layout.fillWidth: true
        }

        // --- Tabs ---
        Tabs {
            Layout.fillWidth: true
            Layout.leftMargin: 24
            Layout.rightMargin: 24
            Layout.topMargin: 16
            activeTab: appWindow.activeTab
            onTabChanged: appWindow.activeTab = tab
        }

        // --- Main Content ---
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 24
            spacing: 24

            // --- Left: Form (2/3 width) ---
            InterventionForm {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width * 0.65
            }

            // --- Right: Info Cards (1/3 width) ---
            ColumnLayout {
                spacing: 16
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width * 0.35

                InfoCard {
                    title: "Caserne"
                    headerColor: "#2563eb"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 180

                    cardContent: ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12

                        Text {
                            text: "Caserne Centrale"
                            font.pixelSize: 18
                            font.bold: true
                            color: "#1f2937"
                        }

                        RowLayout {
                            spacing: 8
                            Image {
                                source: "icons/clock.svg"
                                width: 20
                                height: 20
                            }
                            Text {
                                text: "Temps de réponse: 5 min"
                                font.pixelSize: 14
                                color: "#6b7280"
                            }
                        }

                        Text {
                            text: "12 Pompiers disponibles"
                            font.pixelSize: 14
                            color: "#059669"
                            font.bold: true
                        }
                    }
                }

                InfoCard {
                    title: "Moyens Engagés"
                    headerColor: "#f59e0b"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 200

                    cardContent: ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 15
                        anchors.leftMargin: 40
                        spacing: 8

                        Repeater {
                            model: ["VSAV x2", "FPT x1", "EPA x1"]
                            delegate: Rectangle {
                                width: parent.width
                                height: 36
                                color: "#fef3c7"
                                radius: 6

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData
                                    font.pixelSize: 14
                                    color: "#92400e"
                                }
                            }
                        }
                    }
                }

                InfoCard {
                    title: "Renforts"
                    headerColor: "#10b981"
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    cardContent: ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12

                        Text {
                            text: "Aucun renfort requis"
                            font.pixelSize: 14
                            color: "#6b7280"
                            font.italic: true
                        }

                        Button {
                            text: "Demander Renfort"
                            Layout.fillWidth: false


                            background: Rectangle {
                                color: parent.pressed ? "#059669" : "#10b981"
                                radius: 6
                            }

                            contentItem: Text {
                                text: parent.text
                                color: "white"
                                font.pixelSize: 14
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }
                }
            }
        }
    }
}
