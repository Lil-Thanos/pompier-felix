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

    // Helpers pour le récap
    readonly property var graviteLabels: ["Urgence", "Normal", "Faible"]
    readonly property var graviteColors: ["#dc2626", "#f59e0b", "#10b981"]

    function validateForm() {
        var ok = true
        var messages = []

        // Adresse
        if (champsAdresse.text === "") {
            ok = false
            messages.push("Veuillez saisir l'adresse du sinistre")
        }

        // Type d'intervention
        if (interventionType.currentIndex < 0) {
            ok = false
            messages.push("Veuillez sélectionner le type d'intervention")
        }

        // Gravité
        if (graviteLayout.selectedIndex < 0) {
            ok = false
            messages.push("Veuillez sélectionner le niveau de gravité")
        }

        // Si erreur, afficher un message
        if (!ok) {
            for (var i = 0; i < messages.length; i++) {
                console.log("Validation erreur: " + messages[i])
            }
            errorDialog.open()
        }

        return ok
    }

    // Composant interne réutilisable pour chaque ligne du récap
    component RecapField: ColumnLayout {
        property string label: ""
        property string value: "—"
        property bool multiline: false

        Layout.fillWidth: true
        Layout.leftMargin: 12
        Layout.rightMargin: 12
        spacing: 3

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: "#f3f4f6"
        }

        Text {
            text: label.toUpperCase()
            font.pixelSize: 10
            color: "#9ca3af"
        }

        Text {
            text: value
            font.pixelSize: 12
            font.bold: true
            color: "#374151"
            Layout.fillWidth: true
            wrapMode: multiline ? Text.WordWrap : Text.NoWrap
            elide: multiline ? Text.ElideNone : Text.ElideRight
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // ══════════════════════════════════
        // COLONNE GAUCHE — formulaire
        // ══════════════════════════════════
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            // Form Header
            Rectangle {
                height: 64
                color: "#f3f4f6"
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
                        text: "☎️ Création d'Intervention"
                        font.pixelSize: 20
                        font.bold: true
                        color: "#374151"
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: Qt.formatDateTime(new Date(), "dd/MM/yyyy")
                        font.pixelSize: 14
                        color: "#374151"
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

                            Timer {
                                interval: 60000
                                running: true
                                repeat: true
                                onTriggered: {
                                    dateHeure2.text = Qt.formatTime(new Date(), "HH:mm")
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

                            onClicked: {
                                champsAdresse.text = ""
                                interventionType.currentIndex = "0"
                                graviteLayout.selectedIndex = -1
                                nbVictimes.text = 0
                                commentaireUrgence.text = ""
                                //superviseur.annulerCreationFiche()
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
                                if (validateForm()) {
                                    superviseur.getAdresse(champsAdresse.text)
                                    superviseur.getType(interventionType.model[interventionType.currentIndex].value)
                                    superviseur.getGravite(graviteLayout.selectedIndex)
                                    superviseur.getNbVictime(nbVictimes.text)
                                    superviseur.getCommentaire(commentaireUrgence.text)
                                    superviseur.getHeure(dateHeure1.text, dateHeure2.text)
                                    interventionModel.chargerDepuisBDD()
                                }
                            }
                        }
                    }
                }
            }
        }

        // ══════════════════════════════════
        // SÉPARATEUR VERTICAL
        // ══════════════════════════════════
        Rectangle {
            width: 1
            Layout.fillHeight: true
            color: "#e5e7eb"
        }


        // ══════════════════════════════════
        // COLONNE DROITE — récapitulatif
        // ══════════════════════════════════
        ColumnLayout {
            Layout.preferredWidth: 260
            Layout.fillHeight: true
            spacing: 0

            // En-tête — même style que le formulaire, sans badge
            Rectangle {
                height: 64
                color: "#f3f4f6"
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
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16

                    Text {
                        text: "Récapitulatif"
                        font.pixelSize: 16
                        font.bold: true
                        color: "#374151"
                    }
                }
            }

            // Corps — champs collés en haut, créateur collé en bas
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.leftMargin: 16
                Layout.rightMargin: 16
                spacing: 0

                Item { height: 14 }

                // Gravité — badge en premier champ
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Text {
                        text: "GRAVITÉ"
                        font.pixelSize: 10
                        font.letterSpacing: 1
                        color: "#9ca3af"
                    }

                    //Item { Layout.fillWidth: true }

                    Rectangle {
                        width: graviteBadgeText.implicitWidth + 16
                        height: 22
                        radius: 11
                        color: graviteLayout.selectedIndex >= 0 ? graviteColors[graviteLayout.selectedIndex] : "#e5e7eb"
                        Behavior on color { ColorAnimation { duration: 200 } }

                        Text {
                            id: graviteBadgeText
                            anchors.centerIn: parent
                            text: graviteLayout.selectedIndex >= 0 ? graviteLabels[graviteLayout.selectedIndex] : "—"
                            font.pixelSize: 11
                            font.bold: true
                            color: graviteLayout.selectedIndex >= 0 ? "white" : "#9ca3af"
                            Behavior on color { ColorAnimation { duration: 200 } }
                        }
                    }
                }

                Rectangle { Layout.fillWidth: true; height: 1; color: "#f3f4f6"; Layout.topMargin: 10; Layout.bottomMargin: 10 }

                // Type d'intervention
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4

                    Text {
                        text: "TYPE"
                        font.pixelSize: 10
                        font.letterSpacing: 1
                        color: "#9ca3af"
                    }
                    Text {
                        text: interventionType.currentIndex >= 0
                              ? interventionType.model[interventionType.currentIndex].label
                              : "—"
                        font.pixelSize: 13
                        font.bold: true
                        color: "#374151"
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }
                }

                Rectangle { Layout.fillWidth: true; height: 1; color: "#f3f4f6"; Layout.topMargin: 10; Layout.bottomMargin: 10 }

                // Adresse
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4

                    Text {
                        text: "ADRESSE"
                        font.pixelSize: 10
                        font.letterSpacing: 1
                        color: "#9ca3af"
                    }
                    Text {
                        text: champsAdresse.text !== "" ? champsAdresse.text : "—"
                        font.pixelSize: 13
                        font.bold: true
                        color: "#374151"
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                    }
                }

                Rectangle { Layout.fillWidth: true; height: 1; color: "#f3f4f6"; Layout.topMargin: 10; Layout.bottomMargin: 10 }

                // Victimes + Heure côte à côte
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 16

                    ColumnLayout {
                        spacing: 4
                        Layout.fillWidth: true

                        Text {
                            text: "VICTIMES"
                            font.pixelSize: 10
                            font.letterSpacing: 1
                            color: "#9ca3af"
                        }
                        Text {
                            text: (nbVictimes.text !== "" && nbVictimes.text !== "0") ? nbVictimes.text : "0"
                            font.pixelSize: 20
                            font.bold: true
                            color: (nbVictimes.text !== "" && nbVictimes.text !== "0") ? "#dc2626" : "#374151"
                            Behavior on color { ColorAnimation { duration: 200 } }
                        }
                    }

                    ColumnLayout {
                        spacing: 4
                        Layout.fillWidth: true

                        Text {
                            text: "HEURE"
                            font.pixelSize: 10
                            font.letterSpacing: 1
                            color: "#9ca3af"
                        }
                        Text {
                            text: dateHeure2.text
                            font.pixelSize: 20
                            font.bold: true
                            color: "#374151"
                        }
                    }
                }

                Rectangle { Layout.fillWidth: true; height: 1; color: "#f3f4f6"; Layout.topMargin: 10; Layout.bottomMargin: 10 }

                // Commentaire
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4

                    Text {
                        text: "COMMENTAIRE"
                        font.pixelSize: 10
                        font.letterSpacing: 1
                        color: "#9ca3af"
                    }
                    Text {
                        text: commentaireUrgence.text !== "" ? commentaireUrgence.text : "Aucun commentaire"
                        font.pixelSize: 12
                        color: commentaireUrgence.text !== "" ? "#374151" : "#9ca3af"
                        font.italic: commentaireUrgence.text === ""
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                        maximumLineCount: 4
                        elide: Text.ElideRight
                    }
                }

                // Espace flexible — pousse le créateur vers le bas
                Item { Layout.fillHeight: true }

                // Séparateur bas
                Rectangle { Layout.fillWidth: true; height: 1; color: "#f3f4f6"; Layout.bottomMargin: 12 }

                // Placeholder créateur
                RowLayout {
                    Layout.fillWidth: true
                    Layout.bottomMargin: 16
                    spacing: 8

                    Rectangle {
                        width: 28
                        height: 28
                        radius: 14
                        color: "#e5e7eb"

                        Text {
                            anchors.centerIn: parent
                            text: "?"
                            font.pixelSize: 13
                            font.bold: true
                            color: "#9ca3af"
                        }
                    }

                    ColumnLayout {
                        spacing: 1
                        Layout.fillWidth: true

                        Text {
                            text: "CRÉATEUR"
                            font.pixelSize: 10
                            font.letterSpacing: 1
                            color: "#9ca3af"
                        }
                        Text {
                            id: nomCreateurFicheUrgence
                            text: authManager.username // "—"
                            font.pixelSize: 12
                            font.bold: true
                            color: "#374151"
                        }
                    }
                }
            }
        }
    }
}