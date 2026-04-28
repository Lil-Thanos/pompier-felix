#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>
#include <QIcon>

#include <QSslSocket>
#include <QSslConfiguration>

#include "src/superviseurope.h"
#include "src/interventionmodel.h"
#include "src/gestioncarte.h"
#include "src/authmanager.h"

int main(int argc, char *argv[])
{
    // --- SSL CONFIGURATION ---
    qDebug() << "SSL support:" << QSslSocket::supportsSsl();
    qDebug() << "SSL build version:" << QSslSocket::sslLibraryBuildVersionString();
    qDebug() << "SSL runtime version:" << QSslSocket::sslLibraryVersionString();

    QSslConfiguration sslConfig = QSslConfiguration::defaultConfiguration();
    sslConfig.setPeerVerifyMode(QSslSocket::VerifyPeer);
    sslConfig.setProtocol(QSsl::TlsV1_2OrLater);
    QSslConfiguration::setDefaultConfiguration(sslConfig);


    // --- Qt Quick Application ---
    QGuiApplication app(argc, argv);
    //app.setWindowIcon(QIcon(":/home/felix/Documents/projet/Pompier-Qt-Quick/ui/icons/18.png"));

    //--- Icon App ---
    app.setWindowIcon(QIcon(":/ui/icons/Felix_le_pompier_et_incendie.png"));
    qDebug() << "Icon null?" << app.windowIcon().isNull();

    QQmlApplicationEngine engine;

    // --- Backend instance ---
    SuperviseurOPE superviseur;
    engine.rootContext()->setContextProperty("superviseur", &superviseur);

    // --- Gestion Carte ---
    InterventionsManager manager;
    engine.rootContext()->setContextProperty("interventionsManager", &manager);

    // --- authentification ---
    AuthManager authManager;
    engine.rootContext()->setContextProperty("authManager", &authManager);

    //--- Gestion carte ---
    // PointModel pointModel;
    // pointModel.loadFromDatabase();
    // engine.rootContext()->setContextProperty("pointModel", &pointModel);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    InterventionModel interventionModel;
    interventionModel.chargerDepuisBDD();

    engine.rootContext()->setContextProperty(
        "interventionModel",
        &interventionModel
        );

    // --- Load QML ---
    engine.loadFromModule("Pompier", "MainLogin");

    return app.exec();
}
