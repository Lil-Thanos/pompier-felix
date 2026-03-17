import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Effects
import QtLocation 5.15
import QtPositioning 5.15

Rectangle {
    id: root
    color: "white"
    radius: 16

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 20

        // ── Header ────────────────────────────────────────────────────────
        Rectangle {
            height: 64
            color: "#10b981"
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
                    text: "👥 Gestion des Renforts"
                    font.pixelSize: 20
                    font.bold: true
                    color: "white"
                }

                Item { Layout.fillWidth: true }

                // Compteur de markers
                Rectangle {
                    width: 160
                    height: 36
                    radius: 18
                    color: Qt.rgba(0, 0, 0, 0.2)

                    Text {
                        anchors.centerIn: parent
                        text: "📍 " + markerModel.rowCount() + " caserne(s) affichée(s)"
                        font.pixelSize: 13
                        font.bold: true
                        color: "white"
                    }
                }
            }
        }

        // ── Corps : carte + panneau latéral ───────────────────────────────
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 16

            // ── Carte principale ──────────────────────────────────────────
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 12
                clip: true
                border.color: "#e5e7eb"
                border.width: 1

                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    shadowVerticalOffset: 4
                    shadowColor: "#15000000"
                    shadowBlur: 0.5
                }

                Plugin {
                    id: osmPlugin
                    name: "osm"
                    PluginParameter {
                        name: "osm.mapping.providersrepository.disabled"
                        value: true
                    }
                    PluginParameter {
                        name: "osm.mapping.custom.host"
                        value: "https://tile.openstreetmap.org/"
                    }
                }

                Map {
                    id: map
                    anchors.fill: parent
                    plugin: osmPlugin
                    center: QtPositioning.coordinate(46.6034, 1.8883) // France
                    zoomLevel: 6
                    minimumZoomLevel: 3
                    maximumZoomLevel: 18
                    copyrightsVisible: true

                    // ── Markers depuis le modèle C++ ──────────────────────
                    MapItemView {
                        model: markerModel

                        delegate: MapQuickItem {
                            coordinate: QtPositioning.coordinate(model.latitude, model.longitude)
                            anchorPoint.x: pin.width  / 2
                            anchorPoint.y: pin.height

                            sourceItem: Item {
                                id: pin
                                width: 28
                                height: 38

                                // Cercle
                                Rectangle {
                                    id: pinHead
                                    width: 26
                                    height: 26
                                    radius: 13
                                    color: "#10b981"
                                    border.color: "white"
                                    border.width: 3
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.top: parent.top

                                    Text {
                                        anchors.centerIn: parent
                                        text: "🚒"
                                        font.pixelSize: 13
                                    }
                                }

                                // Pointe
                                Canvas {
                                    width: 12
                                    height: 14
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.bottom: parent.bottom

                                    onPaint: {
                                        var ctx = getContext("2d")
                                        ctx.clearRect(0, 0, width, height)
                                        ctx.fillStyle = "#10b981"
                                        ctx.beginPath()
                                        ctx.moveTo(0, 0)
                                        ctx.lineTo(width, 0)
                                        ctx.lineTo(width / 2, height)
                                        ctx.closePath()
                                        ctx.fill()
                                    }
                                }
                            }
                        }
                    }

                    // ── Boutons zoom ──────────────────────────────────────
                    Column {
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.margins: 12
                        spacing: 4

                        RoundButton {
                            text: "+"
                            font.pixelSize: 20
                            width: 40; height: 40

                            background: Rectangle {
                                radius: 20
                                color: parent.down ? "#059669" : "white"
                                border.color: "#d1d5db"
                                border.width: 1
                            }

                            contentItem: Text {
                                text: "+"
                                font.pixelSize: 22
                                font.bold: true
                                color: "#374151"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            onClicked: map.zoomLevel = Math.min(map.zoomLevel + 1, map.maximumZoomLevel)
                        }

                        RoundButton {
                            text: "−"
                            font.pixelSize: 20
                            width: 40; height: 40

                            background: Rectangle {
                                radius: 20
                                color: parent.down ? "#059669" : "white"
                                border.color: "#d1d5db"
                                border.width: 1
                            }

                            contentItem: Text {
                                text: "−"
                                font.pixelSize: 22
                                font.bold: true
                                color: "#374151"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            onClicked: map.zoomLevel = Math.max(map.zoomLevel - 1, map.minimumZoomLevel)
                        }
                    }

                    // ── Bouton recentrer sur la France ────────────────────
                    RoundButton {
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        anchors.margins: 12
                        width: 40; height: 40

                        background: Rectangle {
                            radius: 20
                            color: parent.down ? "#10b981" : "white"
                            border.color: "#d1d5db"
                            border.width: 1
                        }

                        contentItem: Text {
                            text: "🎯"
                            font.pixelSize: 18
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: {
                            map.center = QtPositioning.coordinate(46.6034, 1.8883)
                            map.zoomLevel = 6
                        }

                        ToolTip.visible: hovered
                        ToolTip.text: "Recentrer sur la France"
                        ToolTip.delay: 500
                    }
                }
            }

            // ── Panneau latéral droit ─────────────────────────────────────
            ColumnLayout {
                Layout.preferredWidth: 260
                Layout.fillHeight: true
                spacing: 12

                // Carte "Légende"
                Rectangle {
                    Layout.fillWidth: true
                    height: legendColumn.implicitHeight + 32
                    radius: 12
                    color: "white"
                    border.color: "#e5e7eb"
                    border.width: 1

                    ColumnLayout {
                        id: legendColumn
                        anchors {
                            top: parent.top; left: parent.left
                            right: parent.right; margins: 16
                        }
                        spacing: 10

                        Text {
                            text: "Légende"
                            font.pixelSize: 14
                            font.bold: true
                            color: "#374151"
                        }

                        // Séparateur
                        Rectangle {
                            Layout.fillWidth: true
                            height: 1
                            color: "#e5e7eb"
                        }

                        Repeater {
                            model: [
                                { color: "#10b981", label: "Caserne disponible" },
                                { color: "#f59e0b", label: "Caserne mobilisée" },
                                { color: "#dc2626", label: "Caserne hors service" }
                            ]

                            delegate: RowLayout {
                                spacing: 10
                                Layout.fillWidth: true

                                Rectangle {
                                    width: 14; height: 14
                                    radius: 7
                                    color: modelData.color
                                    border.color: "white"
                                    border.width: 2

                                    layer.enabled: true
                                    layer.effect: MultiEffect {
                                        shadowEnabled: true
                                        shadowBlur: 0.5
                                        shadowColor: modelData.color
                                        shadowVerticalOffset: 1
                                    }
                                }

                                Text {
                                    text: modelData.label
                                    font.pixelSize: 13
                                    color: "#6b7280"
                                    Layout.fillWidth: true
                                }
                            }
                        }
                    }
                }

                // Carte "Informations"
                Rectangle {
                    Layout.fillWidth: true
                    height: infoColumn.implicitHeight + 32
                    radius: 12
                    color: "white"
                    border.color: "#e5e7eb"
                    border.width: 1

                    ColumnLayout {
                        id: infoColumn
                        anchors {
                            top: parent.top; left: parent.left
                            right: parent.right; margins: 16
                        }
                        spacing: 10

                        Text {
                            text: "Informations"
                            font.pixelSize: 14
                            font.bold: true
                            color: "#374151"
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 1
                            color: "#e5e7eb"
                        }

                        // Zoom actuel
                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                text: "Zoom :"
                                font.pixelSize: 13
                                color: "#6b7280"
                            }
                            Item { Layout.fillWidth: true }
                            Text {
                                text: Math.round(map.zoomLevel)
                                font.pixelSize: 13
                                font.bold: true
                                color: "#374151"
                            }
                        }

                        // Nombre de casernes
                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                text: "Casernes :"
                                font.pixelSize: 13
                                color: "#6b7280"
                            }
                            Item { Layout.fillWidth: true }
                            Text {
                                text: markerModel.rowCount()
                                font.pixelSize: 13
                                font.bold: true
                                color: "#10b981"
                            }
                        }
                    }
                }

                // Bouton "Actualiser les renforts"
                Button {
                    Layout.fillWidth: true
                    height: 44
                    text: "↻  Actualiser les renforts"

                    background: Rectangle {
                        radius: 10
                        color: parent.down ? "#059669" : "#10b981"
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }

                    contentItem: Text {
                        text: parent.text
                        font.pixelSize: 14
                        font.bold: true
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: markerModel.loadFromDatabase()
                }

                // Spacer
                Item { Layout.fillWidth: true; Layout.fillHeight: true }

                // Note "en développement"
                Rectangle {
                    Layout.fillWidth: true
                    height: noteText.implicitHeight + 20
                    radius: 10
                    color: "#f0fdf4"
                    border.color: "#bbf7d0"
                    border.width: 1

                    Text {
                        id: noteText
                        anchors {
                            left: parent.left; right: parent.right
                            top: parent.top; margins: 10
                        }
                        text: "🔧 Fonctionnalités avancées de gestion des renforts disponibles prochainement."
                        font.pixelSize: 12
                        color: "#065f46"
                        wrapMode: Text.Wrap
                        lineHeight: 1.4
                    }
                }
            }
        }
    }
}
