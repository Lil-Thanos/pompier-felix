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

QList<QMap<QString, QVariant>> FicheUrgence::recupererCasernesParDepartement(const QString &departement)
{
    QList<QMap<QString, QVariant>> casernes;

    QString queryStr = "SELECT * FROM casernes_tmp WHERE operator LIKE '%?%';";
    QSqlQuery query(base);

    // Extraire les 2 premiers chiffres du code postal
    QString dept = departement.left(2);
    query.bindValue(0, dept + "%");

    qDebug() << "Recherche casernes pour département:" << dept;

    if (!query.exec()) {
        qDebug() << "Erreur SQL : " << query.lastError().text();
        return casernes;
    }

    //@id,name,lat,lon,city,postcode,operator

    int count = 0;
    while (query.next()) {
        QMap<QString, QVariant> caserne;
        caserne["@id"] = query.value("@id");
        caserne["name"] = query.value("name");
        caserne["lat"] = query.value("lat").toDouble();
        caserne["lon"] = query.value("lon").toDouble();
        caserne["city"] = query.value("city");
        caserne["postcode"] = query.value("postcode");
        caserne["operator"] = query.value("operator");

        casernes.append(caserne);
        count++;
    }

    qDebug() << "Nombre de casernes trouvées:" << count;
    return casernes;
}

QString FicheUrgence::calculerListCasernes(QList<QMap<QString, QVariant>> casernes)
{
    if (casernes.isEmpty()) {
        qDebug() << "Aucune caserne dans la liste!";
        return "Aucune caserne trouvée";
    }

    double latSinistre = 48.75397683641097;
    double lonSinistre = -3.4169741492299357;

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

    return casernePlusProche + " (" + QString::number(distanceMin, 'f', 2) + " km)";
}

