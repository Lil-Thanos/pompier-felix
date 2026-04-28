# Login.qml

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Effects

Rectangle {
    anchors.fill: parent
    color: "#f3f4f6"

    // Carte de login centrée
    Rectangle {
        id: loginCard
        width: 420
        height: columnContent.implicitHeight + 64
        anchors.centerIn: parent
        radius: 16
        color: "white"

        // Ombre portée — même style que ton errorDialog
        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "#20000000"
            shadowVerticalOffset: 8
            shadowHorizontalOffset: 0
            shadowBlur: 24
        }

        ColumnLayout {
            id: columnContent
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: 32
                topMargin: 32
            }
            spacing: 20

            // --- Logo / Icône ---
            Image {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 80
                Layout.preferredHeight: 80

                source: "qrc:/ui/icons/Felix_le_pompier_et_incendie.png"
                fillMode: Image.PreserveAspectFit
            }

            // --- Titre ---
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "Gestion d'Intervention"
                font.pixelSize: 22
                font.weight: Font.DemiBold
                color: "#1f2937"
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "Connectez-vous pour continuer"
                font.pixelSize: 14
                color: "#6b7280"
            }

            // --- Séparateur ---
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "#e5e7eb"
            }

            // --- Champ Username ---
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 6

                Text {
                    text: "Nom d'utilisateur"
                    font.pixelSize: 13
                    font.weight: Font.Medium
                    color: "#374151"
                }

                TextField {
                    id: usernameField
                    Layout.fillWidth: true
                    placeholderText: "Entrez votre identifiant"
                    enabled: !authManager.loading
                    // authManager.loading vient de la Q_PROPERTY
                    // Se désactive automatiquement pendant la requête

                    leftPadding: 12
                    font.pixelSize: 14

                    background: Rectangle {
                        radius: 8
                        color: "white"
                        border.color: usernameField.activeFocus ? "#dc2626" : "#d1d5db"
                        border.width: usernameField.activeFocus ? 2 : 1

                        Behavior on border.color {
                            ColorAnimation { duration: 150 }
                        }
                    }

                    Keys.onReturnPressed: passwordField.forceActiveFocus()
                }
            }

            // --- Champ Password ---
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 6

                Text {
                    text: "Mot de passe"
                    font.pixelSize: 13
                    font.weight: Font.Medium
                    color: "#374151"
                }

                TextField {
                    id: passwordField
                    Layout.fillWidth: true
                    placeholderText: "Entrez votre mot de passe"
                    echoMode: TextInput.Password
                    enabled: !authManager.loading

                    leftPadding: 12
                    font.pixelSize: 14

                    background: Rectangle {
                        radius: 8
                        color: "white"
                        border.color: passwordField.activeFocus ? "#dc2626" : "#d1d5db"
                        border.width: passwordField.activeFocus ? 2 : 1

                        Behavior on border.color {
                            ColorAnimation { duration: 150 }
                        }
                    }

                    Keys.onReturnPressed: doLogin()
                }
            }

            // --- Message d'erreur (caché par défaut) ---
            Rectangle {
                id: errorBox
                Layout.fillWidth: true
                height: errorText.implicitHeight + 16
                radius: 8
                color: "#fef2f2"
                border.color: "#fecaca"
                border.width: 1
                visible: errorText.text !== ""

                Text {
                    id: errorText
                    anchors.centerIn: parent
                    width: parent.width - 24
                    text: ""
                    wrapMode: Text.WordWrap
                    font.pixelSize: 13
                    color: "#991b1b"
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            // --- Bouton Login ---
            Button {
                id: loginButton
                Layout.fillWidth: true
                Layout.preferredHeight: 44
                text: authManager.loading ? "Connexion en cours..." : "Se connecter"
                enabled: !authManager.loading

                onClicked: doLogin()

                contentItem: Text {
                    text: loginButton.text
                    font.pixelSize: 15
                    font.weight: Font.Medium
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    radius: 8
                    // Même palette bleue que ton app (#2563eb)
                    color: loginButton.down    ? "#dc2626" :
                           loginButton.hovered ? "#ED1C1C" : "#D91818"

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }

                    layer.enabled: true
                    layer.effect: MultiEffect {
                        shadowEnabled: true
                        shadowColor: loginButton.down ? "#00000000" : "#403b82f6"
                        shadowVerticalOffset: 2
                        shadowBlur: 8
                    }
                }

                scale: loginButton.down ? 0.97 : 1.0
                Behavior on scale {
                    NumberAnimation { duration: 100 }
                }
            }
        }
    }

    // --- Fonction locale pour lancer le login ---
    function doLogin() {
        errorText.text = ""
        // Appel de la méthode C++ Q_INVOKABLE
        authManager.login(usernameField.text, passwordField.text)
    }

    // --- Écoute les signaux C++ ---
    Connections {
        target: authManager

        function onLoginFailed(message) {
            errorText.text = message
        }

    }
}