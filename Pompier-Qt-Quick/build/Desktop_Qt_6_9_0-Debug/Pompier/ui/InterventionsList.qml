import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Effects


Rectangle {
    id: root
    color: "white"
    radius: 16
    border.color: "#e5e7eb"
    border.width: 1

    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowVerticalOffset: 4
        shadowColor: "#15000000"
        shadowBlur: 0.5
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // --- Header ---
        Rectangle {
            height: 64
            color: "#dc2626"
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
                    text: "📋 Liste des Interventions"
                    font.pixelSize: 20
                    font.bold: true
                    color: "white"
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: Qt.formatDateTime(new Date(), "dd/MM/yyyy")
                    font.pixelSize: 14
                    color: "#fecaca"
                }
            }
        }

        // --- Filters Bar ---
        Rectangle {
            Layout.fillWidth: true
            height: 60
            color: "#f9fafb"
            border.color: "#e5e7eb"
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 24
                anchors.rightMargin: 24
                spacing: 16

                Text {
                    text: "Filtrer par statut:"
                    font.pixelSize: 13
                    font.bold: true
                    color: "#374151"
                }

                Button {
                    id: filterAll
                    text: "Tous"
                    Layout.preferredWidth: 80
                    Layout.preferredHeight: 36

                    property bool isActive: true

                    background: Rectangle {
                        radius: 6
                        color: filterAll.isActive ? "#dc2626" : "#f3f4f6"
                        border.color: filterAll.isActive ? "#dc2626" : "#d1d5db"
                        border.width: 1

                        Behavior on color { ColorAnimation { duration: 150 } }
                    }

                    contentItem: Text {
                        text: filterAll.text
                        font.pixelSize: 12
                        font.bold: filterAll.isActive
                        color: filterAll.isActive ? "white" : "#374151"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        filterAll.isActive = true
                        filterEnCours.isActive = false
                        filterTerminee.isActive = false
                        listView.statusFilter = ""
                    }
                }

                Button {
                    id: filterEnCours
                    text: "En cours"
                    Layout.preferredWidth: 80
                    Layout.preferredHeight: 36

                    property bool isActive: false

                    background: Rectangle {
                        radius: 6
                        color: filterEnCours.isActive ? "#2563eb" : "#f3f4f6"
                        border.color: filterEnCours.isActive ? "#2563eb" : "#d1d5db"
                        border.width: 1

                        Behavior on color { ColorAnimation { duration: 150 } }
                    }

                    contentItem: Text {
                        text: filterEnCours.text
                        font.pixelSize: 12
                        font.bold: filterEnCours.isActive
                        color: filterEnCours.isActive ? "white" : "#374151"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        filterAll.isActive = false
                        filterEnCours.isActive = true
                        filterTerminee.isActive = false
                        listView.statusFilter = "en_cours"
                    }
                }

                Button {
                    id: filterTerminee
                    text: "Terminée"
                    Layout.preferredWidth: 80
                    Layout.preferredHeight: 36

                    property bool isActive: false

                    background: Rectangle {
                        radius: 6
                        color: filterTerminee.isActive ? "#059669" : "#f3f4f6"
                        border.color: filterTerminee.isActive ? "#059669" : "#d1d5db"
                        border.width: 1

                        Behavior on color { ColorAnimation { duration: 150 } }
                    }

                    contentItem: Text {
                        text: filterTerminee.text
                        font.pixelSize: 12
                        font.bold: filterTerminee.isActive
                        color: filterTerminee.isActive ? "white" : "#374151"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        filterAll.isActive = false
                        filterEnCours.isActive = false
                        filterTerminee.isActive = true
                        listView.statusFilter = "terminee"
                    }
                }

                Button {
                    id: refreshButton
                    text: "↻"
                    Layout.preferredWidth: 80
                    Layout.preferredHeight: 36


                    background: Rectangle {
                        radius: 6
                        color: refreshButton.pressed ? "#f3f4f6" : "white"
                        border.color: "#d1d5db"
                        border.width: 1
                    }

                    contentItem: Text {
                        id: idTextRefreshButton
                        text: refreshButton.text
                        font.pixelSize: 12
                        color: "#374151"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        rotationAnimation.start()

                        listView.model = null
                        listView.model = interventionModel //ici
                    }

                    RotationAnimation {
                        id: rotationAnimation
                        target: idTextRefreshButton
                        from: 0
                        to: 360
                        duration: 500
                        easing.type: Easing.InOutQuad
                    }
                }

                Item { Layout.fillWidth: true }
            }
        }

        // --- Interventions List ---
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ListView {
                id: listView
                spacing: 12

                model: interventionModel

                // Propriété de filtre
                property string statusFilter: ""

                delegate: Rectangle {
                    width: listView.width
                    height: itemVisible ? 120 : 0
                    opacity: itemVisible ? 1 : 0
                    visible: itemVisible
                    color: "#ffffff"
                    border.color: "#e5e7eb"
                    border.width: 1
                    radius: 8

                    // Filtre basé sur le statut
                    property bool itemVisible: listView.statusFilter === "" || model.statut === listView.statusFilter

                    Behavior on height {
                        NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
                    }
                    Behavior on opacity {
                        NumberAnimation { duration: 200 }
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 16

                        // Status indicator
                        Rectangle {
                            width: 8
                            height: 8
                            radius: 4
                            Layout.alignment: Qt.AlignTop
                            color: model.statut === "en_cours" ? "#2563eb" : "#059669"
                        }

                        // Main content
                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: 8

                            RowLayout {
                                spacing: 12
                                Layout.fillWidth: true

                                Text {
                                    text: "ID: " + model.id
                                    font.pixelSize: 12
                                    color: "#6b7280"
                                    font.bold: true
                                }

                                Text {
                                    text: model.type
                                    font.pixelSize: 13
                                    color: "#374151"
                                    font.bold: true
                                    Layout.fillWidth: true
                                }

                                Text {
                                    text: model.heure
                                    font.pixelSize: 12
                                    color: "#6b7280"
                                }
                            }

                            Text {
                                text: model.adresse
                                font.pixelSize: 13
                                color: "#374151"
                                Layout.fillWidth: true
                                wrapMode: Text.Wrap
                                elide: Text.ElideRight
                                maximumLineCount: 1
                            }

                            // RowLayout {
                            //     spacing: 16
                            //     Layout.fillWidth: true

                            //     Rectangle {
                            //         width: 80
                            //         height: 24
                            //         radius: 4
                            //         color: model.gravite === "Élevée" ? "#fee2e2" : (model.gravite === "Moyen" ? "#fef3c7" : "#DEDEDE") //"#d1fae5"

                            //         Text {
                            //             anchors.centerIn: parent
                            //             text: "🔴 " + model.gravite
                            //             font.pixelSize: 11
                            //             color: model.gravite === "Élevée" ? "#991b1b" : (model.gravite === "Moyen" ? "#92400e" : "#065f46")
                            //         }
                            //     }

                            RowLayout {
                                spacing: 16
                                Layout.fillWidth: true

                                Rectangle {
                                    width: 90
                                    height: 24
                                    radius: 4
                                    color: {
                                        if (model.gravite === "Urgence") return "#fee2e2"
                                        else if (model.gravite === "Normal") return "#fef3c7"
                                        else return "#d1fae5"  // Faible
                                    }

                                    Text {
                                        anchors.centerIn: parent
                                        text: {
                                            if (model.gravite === "Urgence") return "🔴 Urgence"
                                            else if (model.gravite === "Normal") return "🟠 Normal"
                                            else return "🟢 Faible"
                                        }
                                        font.pixelSize: 11
                                        font.bold: true
                                        color: {
                                            if (model.gravite === "Urgence") return "#dc2626"
                                            else if (model.gravite === "Normal") return "#f59e0b"
                                            else return "#10b981"  // Faible
                                        }
                                    }
                                }


                                Rectangle {
                                    width: 100
                                    height: 24
                                    radius: 4
                                    color: model.statut === "en_cours" ? "#dbeafe" : "#d1fae5"

                                    Text {
                                        anchors.centerIn: parent
                                        text: (model.statut === "en_cours" ? "⏱️ En cours" : "✅ Terminée")
                                        font.pixelSize: 11
                                        color: model.statut === "en_cours" ? "#1e40af" : "#065f46"
                                    }
                                }

                                Rectangle {
                                    width: 80
                                    height: 24
                                    radius: 4
                                    color: "#f3e8ff"

                                    Text {
                                        anchors.centerIn: parent
                                        text: "👥 " + model.victimes
                                        font.pixelSize: 11
                                        color: "#6b21a8"
                                    }
                                }

                                Item { Layout.fillWidth: true }
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: parent.color = "#f9fafb"
                        onExited: parent.color = "#ffffff"
                        onClicked: console.log("Intervention " + model.id + " sélectionnée")
                    }
                }
            }

            // Empty state
            Item {
                anchors.fill: parent
                visible: listView.model.count === 0

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 16

                    Text {
                        text: "📋"
                        font.pixelSize: 64
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: "Aucune intervention"
                        font.pixelSize: 18
                        font.bold: true
                        color: "#374151"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: "Les interventions créées apparaîtront ici"
                        font.pixelSize: 14
                        color: "#6b7280"
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }
        }
    }
}
