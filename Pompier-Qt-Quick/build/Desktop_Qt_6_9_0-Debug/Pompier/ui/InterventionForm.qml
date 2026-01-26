import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Effects

Rectangle {
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

        // Form Header
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
                    text: "📋 Création d'Intervention"
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

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ColumnLayout {
                width: parent.width
                spacing: 20

                Item { height: 8 }

                // Type d'intervention
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.leftMargin: 24
                    Layout.rightMargin: 24
                    spacing: 8

                    Text {
                        text: "Type d'Intervention *"
                        font.pixelSize: 14
                        font.bold: true
                        color: "#374151"
                    }

                    ComboBox {
                        id: interventionType
                        model: [
                            { label: "🔥 Incendie", value: "incendie" },
                            { label: "🚗 Accident", value: "accident" },
                            { label: "🌊 Inondation", value: "inondation" },
                            { label: "🏥 Secours à personne", value: "secours_personne" }
                        ]

                        textRole: "label"
                        Layout.fillWidth: true
                        Layout.minimumHeight: 35

                        // currentIndex: 0
                        // Layout.fillWidth: true
                        // Layout.minimumHeight: 35
                        // font.pixelSize: 14

                        background: Rectangle {
                            radius: 8
                            border.color: parent.pressed ? "#dc2626" : "#d1d5db"
                            border.width: 2
                            color: parent.pressed ? "#fef2f2" : "white"
                        }
                    }
                }

                // Adresse
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.leftMargin: 24
                    Layout.rightMargin: 24
                    spacing: 8

                    Text {
                        text: "Adresse du Sinistre *"
                        font.pixelSize: 14
                        font.bold: true
                        color: "#374151"
                    }

                    TextField {
                        id: champsAdresse
                        placeholderText: "12 Rue de la République, 75001 Paris"
                        Layout.fillWidth: true
                        font.pixelSize: 14

                        background: Rectangle {
                            radius: 8
                            border.color: parent.activeFocus ? "#dc2626" : "#d1d5db"
                            border.width: 2
                            color: parent.activeFocus ? "#fef2f2" : "white"
                        }
                    }
                }

                // Gravité
                ColumnLayout {
                    id: graviteLayout
                    Layout.fillWidth: true
                    Layout.leftMargin: 24
                    Layout.rightMargin: 24
                    spacing: 8

                    property int selectedIndex: -1

                    Text {
                        text: "Niveau de Gravité *"
                        font.pixelSize: 14
                        font.bold: true
                        color: "#374151"
                    }

                    RowLayout {
                        spacing: 12
                        Layout.fillWidth: true

                        Repeater {
                            model: [
                                { label: "🔴 Urgence", color: "#dc2626" },
                                { label: "🟠 Normal", color: "#f59e0b" },
                                { label: "🟢 Faible", color: "#10b981" }
                            ]

                            delegate: Button {
                                Layout.fillWidth: true
                                height: 48

                                property bool isSelected: index === graviteLayout.selectedIndex

                                background: Rectangle {
                                    radius: 8
                                    color: parent.isSelected ? modelData.color : "white"
                                    border.color: modelData.color
                                    border.width: 2
                                    Behavior on color { ColorAnimation { duration: 120 } }
                                }

                                contentItem: Text {
                                    text: modelData.label
                                    font.pixelSize: 13
                                    font.bold: parent.isSelected
                                    color: parent.isSelected ? "white" : modelData.color
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }

                                onClicked: {
                                    graviteLayout.selectedIndex = (graviteLayout.selectedIndex === index) ? -1 : index
                                }
                            }
                        }
                    }
                }


                // Victimes
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.leftMargin: 24
                    Layout.rightMargin: 24
                    spacing: 8

                    Text {
                        text: "Nombre de Victimes"
                        font.pixelSize: 14
                        font.bold: true
                        color: "#374151"
                    }

                    TextField {
                        id: nbVictimes
                        placeholderText: "0"
                        inputMethodHints: Qt.ImhDigitsOnly
                        validator: IntValidator {
                            bottom: 0
                            top: 100
                        }

                        Layout.fillWidth: true
                        font.pixelSize: 14

                        background: Rectangle {
                            radius: 8
                            border.color: parent.activeFocus ? "#dc2626" : "#d1d5db"
                            border.width: 2
                            color: parent.activeFocus ? "#fef2f2" : "white"
                        }
                    }
                }

                // Commentaires
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.leftMargin: 24
                    Layout.rightMargin: 24
                    spacing: 8

                    Text {
                        text: "Informations Complémentaires"
                        font.pixelSize: 14
                        font.bold: true
                        color: "#374151"
                    }

                    TextArea {
                        id: commentaireUrgence
                        placeholderText: "Décrivez la situation, les dangers potentiels, les accès..."
                        Layout.fillWidth: true
                        Layout.preferredHeight: 120
                        font.pixelSize: 14
                        wrapMode: TextArea.Wrap

                        background: Rectangle {
                            radius: 8
                            border.color: parent.activeFocus ? "#dc2626" : "#d1d5db"
                            border.width: 2
                            color: parent.activeFocus ? "#fef2f2" : "white"
                        }
                    }
                }

                // Date / Heure
                RowLayout {
                    spacing: 16
                    Layout.fillWidth: true
                    Layout.leftMargin: 24
                    Layout.rightMargin: 24

                    ColumnLayout {
                        spacing: 8
                        Layout.fillWidth: true

                        Text {
                            text: "Date"
                            font.pixelSize: 14
                            font.bold: true
                            color: "#374151"
                        }

                        TextField {
                            id: dateHeure1
                            text: Qt.formatDate(new Date(), "dd/MM/yyyy")
                            Layout.fillWidth: true
                            font.pixelSize: 14

                            background: Rectangle {
                                radius: 8
                                border.color: "#d1d5db"
                                border.width: 2
                            }
                        }
                    }

                    ColumnLayout {
                        spacing: 8
                        Layout.fillWidth: true

                        Text {
                            text: "Heure"
                            font.pixelSize: 14
                            font.bold: true
                            color: "#374151"
                        }

                        TextField {
                            id: dateHeure2
                            text: Qt.formatTime(new Date(), "HH:mm")
                            Layout.fillWidth: true
                            font.pixelSize: 14

                            background: Rectangle {
                                radius: 8
                                border.color: "#d1d5db"
                                border.width: 2
                            }
                        }
                    }
                }

                // Buttons
                RowLayout {
                    spacing: 16
                    Layout.fillWidth: true
                    Layout.leftMargin: 24
                    Layout.rightMargin: 24
                    Layout.topMargin: 8
                    Layout.bottomMargin: 24

                    Button {
                        text: "Annuler"
                        Layout.fillWidth: true
                        height: 48
                        font.pixelSize: 16

                        background: Rectangle {
                            color: parent.pressed ? "#f3f4f6" : "white"
                            radius: 8
                            border.color: "#d1d5db"
                            border.width: 2
                        }

                        contentItem: Text {
                            text: parent.text
                            color: "#6b7280"
                            font.pixelSize: parent.font.pixelSize
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    Button {
                        text: "✓ Valider l'Intervention"
                        Layout.fillWidth: true
                        Layout.preferredWidth: 300
                        height: 48
                        font.pixelSize: 16

                        background: Rectangle {
                            color: parent.pressed ? "#b91c1c" : "#dc2626"
                            radius: 8

                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                        }

                        contentItem: Text {
                            text: parent.text
                            color: "white"
                            font.pixelSize: parent.font.pixelSize
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: {
                            superviseur.getAdresse(champsAdresse.text)
                            superviseur.getType(interventionType.model[interventionType.currentIndex].value)
                            superviseur.getGravite(graviteLayout.selectedIndex)
                            superviseur.getNbVictime(nbVictimes.text)
                            superviseur.getCommentaire(commentaireUrgence.text)
                            superviseur.getHeure(dateHeure1.text, dateHeure2.text)
                        }
                    }
                }
            }
        }
    }
}
