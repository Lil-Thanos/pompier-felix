#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>

#include <QSslSocket>
#include <QSslConfiguration>

#include "src/superviseurope.h"
#include "src/superviseurope.h"

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
    QQmlApplicationEngine engine;

    // --- Backend instance ---
    SuperviseurOPE superviseur;
    engine.rootContext()->setContextProperty("superviseur", &superviseur);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    // --- Load QML ---
    engine.loadFromModule("Pompier", "App");

    return app.exec();
}
