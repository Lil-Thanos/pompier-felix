import QtQuick 2.15
import QtLocation 5.15
import QtQuick.Controls 2.15

MapQuickItem {
    id: root
    anchorPoint.x: 14
    anchorPoint.y: 14

    property string markerColor: "#F39C12"
    property int    count: 1
    property var   interventions: []
    property var   mapRef: null

    Component {
        id: popupComponent
        Popup {
            id: popup
            width: 260; padding: 0
            modal: false; focus: false
            closePolicy: Popup.CloseOnPressOutside
            property var iList: []

            background: Rectangle {
                color: "white"; radius: 10
                border.color: "#e5e7eb"; border.width: 1
            }

            contentItem: Column {
                width: popup.width; spacing: 0

                // En-tête vert comme le header de la page
                Rectangle {
                    width: parent.width; height: 36
                    color: "#f3f4f6"; radius: 10
                    Rectangle {
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 10
                        color: parent.color
                    }
                    Text {
                        anchors.centerIn: parent
                        text: popup.iList.length + " intervention(s)"
                        font.bold: true; font.pixelSize: 13; color: "#6b7280"
                    }
                }

                ScrollView {
                    width: popup.width
                    height: Math.min(popup.iList.length * 84, 252)
                    clip: true
                    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                    Column {
                        width: popup.width; spacing: 0
                        Repeater {
                            model: popup.iList
                            delegate: Rectangle {
                                width: popup.width; height: 82
                                color: index % 2 === 0 ? "#f9fafb" : "white"
                                Rectangle {
                                    anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
                                    width: 4
                                    color: modelData.gravite === "Urgence" ? "#E74C3C"
                                           : modelData.gravite === "Normal"  ? "#F39C12" : "#27AE60"
                                }
                                Column {
                                    anchors { left: parent.left; leftMargin: 12; verticalCenter: parent.verticalCenter }
                                    spacing: 3
                                    Text { text: modelData.adresse ?? "–"; font.pixelSize: 12; font.bold: true; color: "#374151"; elide: Text.ElideRight; width: 234 }
                                    Text { text: "Type : "    + (modelData.type    ?? "–"); font.pixelSize: 11; color: "#6b7280" }
                                    Text { text: "Gravité : " + (modelData.gravite ?? "–"); font.pixelSize: 11; color: "#6b7280" }
                                }
                            }
                        }
                    }
                }

                // Bouton fermer
                Rectangle {
                    width: popup.width; height: 32
                    color: closeHover.containsMouse ? "#f3f4f6" : "#f9fafb"
                    radius: 10
                    Rectangle { anchors.top: parent.top; width: parent.width; height: 10; color: parent.color }
                    Text { anchors.centerIn: parent; text: "Fermer"; font.pixelSize: 12; color: "#6b7280" }
                    MouseArea { id: closeHover; anchors.fill: parent; hoverEnabled: true; onClicked: popup.close() }
                }
            }
        }
    }

    sourceItem: Item {
        width: 28; height: 28
        Rectangle {
            id: halo; anchors.centerIn: parent
            width: 28; height: 28; radius: 14
            color: root.markerColor; opacity: 0
            Behavior on width   { NumberAnimation { duration: 150 } }
            Behavior on height  { NumberAnimation { duration: 150 } }
            Behavior on opacity { NumberAnimation { duration: 150 } }
        }
        Rectangle {
            anchors.centerIn: parent
            width: 24; height: 24; radius: 12
            color: root.markerColor
            border.color: Qt.darker(root.markerColor, 1.3)
            border.width: 1.5
            Text {
                anchors.centerIn: parent; text: root.count
                color: "white"; font.bold: true
                font.pixelSize: root.count > 9 ? 9 : 11
            }
        }
        MouseArea {
            anchors.fill: parent; hoverEnabled: true
            onEntered: { halo.width = 38; halo.height = 38; halo.opacity = 0.3 }
            onExited:  { halo.width = 28; halo.height = 28; halo.opacity = 0 }
            onClicked: {
                if (!root.mapRef) return
                var pt = root.mapRef.fromCoordinate(root.coordinate, false)
                var pw = 260
                var ph = Math.min(root.interventions.length * 84 + 68, 320)
                var px = pt.x + 20
                var py = pt.y - 20
                if (px + pw > root.mapRef.width  - 10) px = pt.x - pw - 10
                if (py + ph > root.mapRef.height - 10) py = root.mapRef.height - ph - 10
                if (px < 10) px = 10
                if (py < 10) py = 10
                var p = popupComponent.createObject(root.mapRef, { x: px, y: py, iList: root.interventions })
                if (p) p.open()
            }
        }
    }
}