#include "geocoding.h"

Geocoding::Geocoding(QObject *parent) : QObject(parent)
{
    manager = new QNetworkAccessManager(this);
    connect(manager, &QNetworkAccessManager::finished, this, &Geocoding::onGeocodingFinished);
}

void Geocoding::obtenirCoordonnees(const QString &adresse)
{
    QUrl url("https://nominatim.openstreetmap.org/search");

    QUrlQuery query;
    query.addQueryItem("q", adresse);
    query.addQueryItem("format", "json");
    query.addQueryItem("addressdetails", "1");

    query.addQueryItem("email", "felix@gmail.com");

    url.setQuery(query);

    QNetworkRequest request(url);

    request.setRawHeader("User-Agent",
                         "PompierApp/1.0 (contact: felix@gmail.com)");
    request.setRawHeader("Accept", "application/json");
    request.setRawHeader("Accept-Language", "fr-FR,fr;q=0.9");

    manager->get(request);
    qDebug() << "Requête Nominatim :" << url.toString(QUrl::FullyEncoded);

}


void Geocoding::onGeocodingFinished(QNetworkReply *reply)
{
    if (reply->error() != QNetworkReply::NoError) {
        qDebug() << "Erreur : " << reply->errorString();
        return;
    }

    QByteArray response_data = reply->readAll();
    QJsonDocument jsonDoc = QJsonDocument::fromJson(response_data);
    QJsonArray jsonArray = jsonDoc.array();

    if (jsonArray.isEmpty()) {
        qDebug() << "Adresse non trouvée";
        emit coordonneesRecues(0.0, 0.0, "0000");
        return;
    }

    QJsonObject jsonObject = jsonArray.first().toObject();

    double      lat         = jsonObject.value("lat").toString().toDouble();
    double      lon         = jsonObject.value("lon").toString().toDouble();

    QJsonObject     address = jsonObject.value("address").toObject();
    QString         code_postal = address.value("postcode").toString();


    qDebug() << "Latitude:" << lat << ", Longitude:" << lon << ", code postal: " << code_postal;

    emit coordonneesRecues(lat, lon, code_postal);
    reply->deleteLater();
}

