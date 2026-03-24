#include "gestioncarte.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>
#include <QVariantMap>

InterventionsManager::InterventionsManager(QObject* parent) : QObject(parent)
{
    // Se connecter à la base SQLite
    m_db = QSqlDatabase::addDatabase("QSQLITE");
    m_db.setDatabaseName("/home/felix/Documents/projet/CasernesBZH.db");

    if (!m_db.open()) {
        qWarning() << "Erreur ouverture BDD:" << m_db.lastError().text();
    }
}

InterventionsManager::~InterventionsManager()
{
    if (m_db.isOpen()) {
        m_db.close();
    }
}

QVariantList InterventionsManager::getEnCoursInterventions()
{
    QVariantList list;

    QString requete = R"(
        SELECT id, adresse, type, gravite, casernes_assigne
        FROM interventions
        WHERE statut = 'en_cours';
    )";

    QSqlQuery query(m_db);

    if (!query.exec(requete)) {
        qWarning() << "Erreur requête:" << query.lastError().text();
        return list;
    }

    int count = 0;

    while (query.next()) {
        QVariantMap item;

        int id = query.value("id").toInt();
        QString adresse = query.value("adresse").toString();
        QString type = query.value("type").toString();
        QString gravite = query.value("gravite").toString();
        QString caserneBrut = query.value("casernes_assigne").toString();

        QString caserneClean = getNomcaserne(caserneBrut);

        qDebug() << "Caserne brute:" << caserneBrut;
        qDebug() << "Caserne clean:" << caserneClean;

        QSqlQuery q2(m_db);
        q2.prepare("SELECT lat, lon FROM casernes_tmp WHERE name = ?");
        q2.addBindValue(caserneClean);

        double lat = 0;
        double lon = 0;

        if (q2.exec() && q2.next()) {
            lat = q2.value(0).toDouble();
            lon = q2.value(1).toDouble();
        } else {
            qWarning() << "Caserne introuvable:" << caserneClean;
        }

        // 🧾 Remplissage
        item["id"] = id;
        item["adresse"] = adresse;
        item["type"] = type;
        item["gravite"] = gravite;
        item["caserne"] = caserneClean;
        item["lat"] = lat;
        item["lon"] = lon;

        list.append(item);
        count++;
    }

    qDebug() << "Total interventions:" << count;

    return list;
}

QString InterventionsManager::getNomcaserne(QString input)
{
    QRegularExpression regex(R"(\s*\(\d+(\.\d+)?\s*km\))");
    QString result = input;
    result.remove(regex);
    return result.trimmed();
}