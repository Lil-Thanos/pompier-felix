# MainLogin.qml
import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    id: appWindow
    width: 1920
    height: 1080
    visible: true
    title: "Gestion d'Intervention"

    Loader {
        id: pageLoader
        anchors.fill: parent
        source: "Login.qml"
    }


    Connections {
        target: authManager

        function onLoginSuccess() {
            pageLoader.source = "App.qml"
        }
    }
}