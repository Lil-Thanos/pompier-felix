
// MapView.qml — fichier principal
import QtQuick 2.15
import QtQuick.Window 2.15
import QtLocation 5.15
import QtPositioning 5.15
import QtQuick.Controls 2.15

Window {
    width: 800; height: 600
    visible: true
    title: "Carte Qt – Interventions"

    Plugin { id: mapPlugin; name: "osm" }

    Map {
        id: map
        anchors.fill: parent
        plugin: mapPlugin
        center: QtPositioning.coordinate(48.1845, -2.7621)
        zoomLevel: 8

        // Composant réutilisable pour chaque marqueur
        Component {
            id: markerComponent
            MarkerItem { mapRef: map }
        }

        Component.onCompleted: {
            var interventions = interventionsManager.getEnCoursInterventions();

            // Grouper par coordonnées
            var positions = {};
            for (var i = 0; i < interventions.length; i++) {
                var item = interventions[i];
                if (!item.lat || !item.lon) continue;
                var key = item.lat + "," + item.lon;
                if (!positions[key]) positions[key] = [];
                positions[key].push(item);
            }

            // Créer un marqueur par position unique
            for (var key in positions) {
                var list = positions[key];
                var color = "#F39C12"; // orange par défaut
                for (var j = 0; j < list.length; j++) {
                    if (list[j].gravite === "Urgence") { color = "#E74C3C"; break; }
                    else if (list[j].gravite === "Normal") color = "#27AE60";
                }

                var marker = markerComponent.createObject(map, {
                    coordinate: QtPositioning.coordinate(list[0].lat, list[0].lon),
                    markerColor: color,
                    count: list.length,
                    interventions: list
                });
                map.addMapItem(marker);
            }
        }
    }
}

