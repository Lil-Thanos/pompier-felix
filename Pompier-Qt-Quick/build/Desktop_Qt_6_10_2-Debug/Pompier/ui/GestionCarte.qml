import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtLocation 5.15
import QtPositioning 5.15

Item {
    id: root

    onVisibleChanged: {
        if (visible) {
            reloadMarkers()
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "white"
        radius: 16

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 20

            // ── Header ───────────────────────────────────────────────────
            Rectangle {
                height: 64
                color:  "#dc2626"
                Layout.fillWidth: true
                radius: 16
                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width; height: 16
                    color: parent.color
                }
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 24
                    anchors.rightMargin: 24
                    Text {
                        text: "👥 Gestion des Renforts"
                        font.pixelSize: 20; font.bold: true
                        color: "white"
                    }
                    Item { Layout.fillWidth: true }
                    // Compteurs interventions
                    RowLayout {
                        spacing: 8
                        Repeater {
                            model: [
                                { label: "Urgence", color: "#E74C3C", count: urgenceCount },
                                { label: "Moyen",  color: "#F39C12", count: attenteCount },
                                { label: "Faible",   color: "#27AE60", count: normalCount }
                            ]
                            delegate: Rectangle {
                                width: 72; height: 28; radius: 6
                                color: Qt.rgba(0,0,0,0.2)
                                border.color: modelData.color; border.width: 1
                                RowLayout {
                                    anchors.centerIn: parent; spacing: 4
                                    Rectangle { width: 8; height: 8; radius: 4; color: modelData.color }
                                    Text {
                                        text: modelData.label
                                        font.pixelSize: 11; color: "white"
                                    }
                                }
                            }
                        }
                        Rectangle {
                            width: 70; height: 28; radius: 6
                            color: "white"
                            Text {
                                anchors.centerIn: parent
                                text: "DEMO"
                                font.pixelSize: 12; font.bold: true
                                color: "red"
                            }
                        }
                    }
                }
            }

            // ── Légende + bouton recentrer ────────────────────────────────
            // RowLayout {
            //     Layout.fillWidth: true
            //     spacing: 12
            //     Text {
            //         text: "Interventions en cours"
            //         font.pixelSize: 14; font.bold: true
            //         color: "#374151"
            //     }
            //     Item { Layout.fillWidth: true }
            //     // Pastilles légende
            //     Repeater {
            //         model: [
            //             { label: "Urgence", color: "#E74C3C" },
            //             { label: "Attente",  color: "#F39C12" },
            //             { label: "Normal",   color: "#27AE60" }
            //         ]
            //         delegate: RowLayout {
            //             spacing: 4
            //             Rectangle { width: 12; height: 12; radius: 6; color: modelData.color }
            //             Text { text: modelData.label; font.pixelSize: 12; color: "#6b7280" }
            //         }
            //     }
            //     // Bouton recentrer
            //     Rectangle {
            //         width: 110; height: 30; radius: 8
            //         color: recenterHover.containsMouse ? "#0ea571" : "#10b981"
            //         Behavior on color { ColorAnimation { duration: 120 } }
            //         Text {
            //             anchors.centerIn: parent
            //             text: "⟳  Recentrer"
            //             font.pixelSize: 12; color: "white"
            //         }
            //         MouseArea {
            //             id: recenterHover
            //             anchors.fill: parent
            //             hoverEnabled: true
            //             onClicked: {
            //                 map.center = QtPositioning.coordinate(48.1845, -2.7621)
            //                 map.zoomLevel = 8
            //             }
            //         }
            //     }
            // }

            // ── Carte ─────────────────────────────────────────────────────
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 12
                clip: true
                border.color: "#e5e7eb"
                border.width: 1

                Plugin { id: mapPlugin; name: "osm" }

                Map {
                    id: map
                    anchors.fill: parent
                    plugin: mapPlugin
                    center: QtPositioning.coordinate(48.1845, -2.7621)
                    zoomLevel: 8

                    Component {
                        id: markerComponent
                        MarkerItem { mapRef: map }
                    }

                    Component.onCompleted: loadMarkers()
                }

                // Overlay chargement
                Rectangle {
                    id: loadingOverlay
                    anchors.fill: parent
                    color: "#80ffffff"
                    visible: map.mapReady === false
                    BusyIndicator { anchors.centerIn: parent; running: parent.visible }
                }
            }
        }
    }

    // ── Propriétés compteurs (bindées sur les données) ────────────
    property int urgenceCount: 0
    property int attenteCount: 0
    property int normalCount: 0

    // ── Fonction de chargement des marqueurs ──────────────────────
    function loadMarkers() {
        var interventions = interventionsManager.getEnCoursInterventions()
        var positions = {}
        var urg = 0, att = 0, nor = 0

        for (var i = 0; i < interventions.length; i++) {
            var item = interventions[i]
            if (!item.lat || !item.lon) continue
            var key = item.lat + "," + item.lon
            if (!positions[key]) positions[key] = []
            positions[key].push(item)
            // Comptage gravités
            if (item.gravite === "Urgence")     urg++
            else if (item.gravite === "Normal")  nor++
            else                                  att++
        }

        urgenceCount = urg; attenteCount = att; normalCount = nor

        for (var key in positions) {
            var list = positions[key]
            var color = "#F39C12"
            for (var j = 0; j < list.length; j++) {
                if (list[j].gravite === "Urgence") { color = "#E74C3C"; break }
                else if (list[j].gravite === "Normal") color = "#27AE60"
            }
            var marker = markerComponent.createObject(map, {
                coordinate: QtPositioning.coordinate(list[0].lat, list[0].lon),
                markerColor: color,
                count: list.length,
                interventions: list
            })
            map.addMapItem(marker)
        }
    }
}