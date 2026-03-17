import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Effects


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

        // --- Tab Content ---
        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 24
            currentIndex: {
                if (appWindow.activeTab === "nouvelle") return 0
                if (appWindow.activeTab === "alerte") return 1
                if (appWindow.activeTab === "gestion") return 2
                return 0
            }

            // Tab 1: "Nouvelle Intervention" avec ses cards
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
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
                        Layout.preferredHeight: 200

                        cardContent: ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 12

                            Text {
                                id: retourCaserne
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
                                    visible: false
                                }
                                Text {
                                    id: tempsTrajet
                                    text: ""
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

                    Connections {
                        target: superviseur

                        function onDistanceMinCalculee(distance) {
                            retourCaserne.text = distance
                        }

                        function onMessageInfo(msg) {
                            retourCaserne.text = msg
                        }

                        function onAfficherTempsTrajet(temps) {
                            tempsTrajet.text = temps
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

            // Tab 2: "Liste des Interventions"
            InterventionsList {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            // Tab 3: "Gestion des Renforts" (page vide)
            EmptyTab {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }

    Dialog {
        id: errorDialog
        modal: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        width: Math.min(parent ? parent.width * 0.6 : 400, 500)

        // Entrée avec animation
        enter: Transition {
            NumberAnimation {
                property: "opacity"
                from: 0.0
                to: 1.0
                duration: 200
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                property: "scale"
                from: 0.9
                to: 1.0
                duration: 200
                easing.type: Easing.OutBack
            }
        }

        exit: Transition {
            NumberAnimation {
                property: "opacity"
                from: 1.0
                to: 0.0
                duration: 150
            }
        }

        background: Rectangle {
            id: bgRect
            radius: 16
            color: "white"
            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: "#30000000"
                shadowVerticalOffset: 8
                shadowHorizontalOffset: 0
                shadowBlur: 24
            }
        }

        contentItem: ColumnLayout {
            spacing: 20

            // Icône d'erreur animée
            Item {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 64
                Layout.preferredHeight: 64

                Rectangle {
                    id: iconCircle
                    anchors.centerIn: parent
                    width: 64
                    height: 64
                    radius: 32
                    color: "#fee2e2"

                    // Animation de pulsation au démarrage
                    SequentialAnimation on scale {
                        running: errorDialog.visible
                        NumberAnimation { from: 0.8; to: 1.0; duration: 300; easing.type: Easing.OutBack }
                    }
                }

                // Icône X
                Canvas {
                    id: errorIcon
                    anchors.centerIn: parent
                    width: 32
                    height: 32

                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.clearRect(0, 0, width, height)
                        ctx.strokeStyle = "#dc2626"
                        ctx.lineWidth = 3
                        ctx.lineCap = "round"

                        // Ligne gauche-droite
                        ctx.beginPath()
                        ctx.moveTo(8, 8)
                        ctx.lineTo(24, 24)
                        ctx.stroke()

                        // Ligne droite-gauche
                        ctx.beginPath()
                        ctx.moveTo(24, 8)
                        ctx.lineTo(8, 24)
                        ctx.stroke()
                    }

                    NumberAnimation on rotation {
                        running: errorDialog.visible
                        from: -10
                        to: 0
                        duration: 400
                        easing.type: Easing.OutElastic
                    }
                }
            }

            // Titre
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "Erreur de validation"
                font.pixelSize: 20
                font.weight: Font.DemiBold
                color: "#1f2937"
            }

            // Message d'erreur
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: errorMessage.implicitHeight + 24
                radius: 8
                color: "#fef2f2"
                border.color: "#fecaca"
                border.width: 1

                Text {
                    id: errorMessage
                    anchors.centerIn: parent
                    anchors.margins: 12
                    width: parent.width - 24
                    text: "Veuillez remplir tous les champs obligatoires marqués d'un astérisque (*)"
                    wrapMode: Text.Wrap
                    font.pixelSize: 14
                    color: "#991b1b"
                    horizontalAlignment: Text.AlignHCenter
                    lineHeight: 1.4
                }
            }

            // Bouton OK personnalisé
            Button {
                id: okButton
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 120
                Layout.preferredHeight: 44
                text: "Compris"

                contentItem: Text {
                    text: okButton.text
                    font.pixelSize: 15
                    font.weight: Font.Medium
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    radius: 8
                    color: okButton.down ? "#b91c1c" : (okButton.hovered ? "#dc2626" : "#ef4444")

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }

                    layer.enabled: true
                    layer.effect: MultiEffect {
                        shadowEnabled: true
                        shadowColor: okButton.down ? "#00000000" : "#40dc2626"
                        shadowVerticalOffset: 2
                        shadowHorizontalOffset: 0
                        shadowBlur: 4
                    }
                }

                onClicked: errorDialog.accept()

                // Animation au survol
                scale: okButton.down ? 0.95 : 1.0
                Behavior on scale {
                    NumberAnimation { duration: 100 }
                }
            }
        }

        // Centrer le Dialog
        Component.onCompleted: {
            if (parent) {
                x = (parent.width - width) / 2
                y = (parent.height - height) / 2
            }
        }
    }
}


