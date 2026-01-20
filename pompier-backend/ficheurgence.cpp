#include "ficheurgence.h"

FicheUrgence::FicheUrgence(QObject *parent)
    : QObject(parent)
{
    base = QSqlDatabase::addDatabase("QSQLITE");
}

void FicheUrgence::connecterBDD()
{
    base.setDatabaseName("/home/felix/Documents/projet/CasernesBZH.db");
    if (!base.open()) {
        qDebug() << "Impossible d'ouvrir la base de données!";
    } else {
        qDebug() << "Base de données ouverte avec succès.";
    }
}

void FicheUrgence::deconnecterBDD()
{
    if (base.isOpen())
        base.close();

    QSqlDatabase::removeDatabase(QSqlDatabase::defaultConnection);
}

double FicheUrgence::calculerHaversine(double longitude_s, double latitude_s, double longitude_t, double latitude_t)
{
    // Conversion degrés to radians
    double lat1 = latitude_s * M_PI / 180.0;
    double lon1 = longitude_s * M_PI / 180.0;
    double lat2 = latitude_t * M_PI / 180.0;
    double lon2 = longitude_t * M_PI / 180.0;

    double d = _R * acos(
                   cos(lat1) * cos(lat2) * cos(lon2 - lon1) +
                   sin(lat1) * sin(lat2)
                   );

    return d; // return la distance entre la caserne et le sinistre
}

QList<QMap<QString, QVariant>> FicheUrgence::recupererCasernesParDepartement(QString departement)
{
    QList<QMap<QString, QVariant>> casernes;

    qDebug() << "=== DIAGNOSTIC ===";
    qDebug() << "Code postal reçu:" << departement;

    QString dept = departement.trimmed().left(2);
    QString pattern = "%SDIS " + dept + "%";

    qDebug() << "Département extrait:" << dept;
    qDebug() << "Pattern de recherche:" << pattern;

    QString queryStr = "SELECT * FROM casernes_tmp WHERE operator LIKE ?";
    QSqlQuery query(base);

    if (!query.prepare(queryStr)) {
        qDebug() << "Erreur prepare :" << query.lastError().text();
        return casernes;
    }

    query.bindValue(0, pattern);

    if (!query.exec()) {
        qDebug() << "Erreur SQL :" << query.lastError().text();
        return casernes;
    }

    int count = 0;
    while (query.next()) {
        QMap<QString, QVariant> caserne;
        caserne["@id"] = query.value("@id");
        caserne["name"] = query.value("name");

        double lat = query.value("lat").toDouble();
        double lon = query.value("lon").toDouble();

        if (lat == 0.0 || lon == 0.0) {
            lat = query.value("@lat").toDouble();
            lon = query.value("@lon").toDouble();
        }

        caserne["lat"] = lat;
        caserne["lon"] = lon;
        caserne["city"] = query.value("city");
        caserne["postcode"] = query.value("postcode");
        caserne["operator"] = query.value("operator");

        qDebug() << "✓ Caserne trouvée:" << caserne["name"].toString()
                 << "| Operator:" << caserne["operator"].toString()
                 << "| Coords:" << lat << "," << lon;

        casernes.append(caserne);
        count++;
    }

    qDebug() << "Total casernes trouvées:" << count;
    return casernes;
}

QString FicheUrgence::calculerListCasernes(QList<QMap<QString, QVariant>> casernes, double latSinistre, double lonSinistre)
{
    if (casernes.isEmpty()) {
        qDebug() << "Aucune caserne dans la liste!";
        return "Aucune caserne trouvée";
    }

    double distanceMin = std::numeric_limits<double>::max();
    QString casernePlusProche = "Aucune";

    for (const auto &caserne : casernes)
    {
        double lat = caserne["lat"].toDouble();
        double lon = caserne["lon"].toDouble();

        if (lat == 0 || lon == 0) {
            qDebug() << "Coordonnées invalides pour:" << caserne["name"].toString();
            continue;
        }

        double distance = calculerHaversine(lonSinistre, latSinistre, lon, lat);
        qDebug() << "Caserne:" << caserne["name"].toString() << "Distance:" << distance << "km";

        if (distance < distanceMin)
        {
            distanceMin = distance;
            casernePlusProche = caserne["name"].toString();
        }
    }

    qDebug() << "Caserne la plus proche :" << casernePlusProche << "Distance :" << distanceMin << "km";
    return casernePlusProche + "\n(" + QString::number(distanceMin, 'f', 2) + " km)";
}

