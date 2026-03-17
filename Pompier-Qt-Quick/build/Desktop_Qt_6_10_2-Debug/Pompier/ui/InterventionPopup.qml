// InterventionPopup.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects

Popup {
    id: root
    width: 260
    padding: 0
    modal: false
    focus: false
    closePolicy: Popup.CloseOnPressOutside

    property var interventionList: []

    background: Rectangle {
        color: "#FFFFFF"
        radius: 10
        border.color: "#DDDDDD"
        border.width: 1
        // Ombre portée via layer
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0; verticalOffset: 4
            radius: 12; samples: 17
            color: "#40000000"
        }
    }

    contentItem: Column {
        width: root.width
        spacing: 0

        // En-tête
        Rectangle {
            width: parent.width; height: 36
            color: "#F8F8F8"
            radius: 10
            Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 10; color: parent.color }
            Text {
                anchors.centerIn: parent
                text: root.interventionList.length + " intervention(s)"
                font.bold: true; font.pixelSize: 13
                color: "#333333"
            }
        }

        // Liste scrollable
        ScrollView {
            width: root.width
            height: Math.min(root.interventionList.length * 90, 270)
            clip: true
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

            Column {
                width: root.width
                spacing: 1
                Repeater {
                    model: root.interventionList
                    delegate: Rectangle {
                        width: root.width; height: 82
                        color: index % 2 === 0 ? "#FAFAFA" : "#FFFFFF"
                        Rectangle {
                            anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
                            width: 4
                            color: modelData.gravite === "Urgence" ? "#E74C3C"
                                 : modelData.gravite === "Normal"  ? "#27AE60" : "#F39C12"
                        }
                        Column {
                            anchors { left: parent.left; leftMargin: 14; verticalCenter: parent.verticalCenter }
                            spacing: 3
                            Text { text: modelData.adresse; font.pixelSize: 12; font.bold: true; color: "#222"; elide: Text.ElideRight; width: 230 }
                            Text { text: "Type : " + modelData.type; font.pixelSize: 11; color: "#555" }
                            Text { text: "Gravité : " + modelData.gravite; font.pixelSize: 11; color: "#555" }
                        }
                    }
                }
            }
        }

        // Bouton fermer
        Rectangle {
            width: root.width; height: 32
            color: closeArea.containsMouse ? "#EFEFEF" : "#F8F8F8"
            radius: 10
            Rectangle { anchors.top: parent.top; width: parent.width; height: 10; color: parent.color }
            Text { anchors.centerIn: parent; text: "Fermer"; font.pixelSize: 12; color: "#666" }
            MouseArea { id: closeArea; anchors.fill: parent; hoverEnabled: true; onClicked: root.close() }
        }
    }
}