#ifndef GEOCODING_H
#define GEOCODING_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QUrl>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>
#include <QUrlQuery>


class Geocoding : public QObject
{
    Q_OBJECT

public:
    explicit    Geocoding(QObject *parent = nullptr);

    void        obtenirCoordonnees(const QString &adresse);

private slots:
    void        onGeocodingFinished(QNetworkReply *reply);

signals:
    void        coordonneesRecues(double latitude, double longitude, QString code_postal);

private:
    QNetworkAccessManager *manager;
};

#endif // GEOCODING_H

