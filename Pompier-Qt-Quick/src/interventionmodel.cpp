#include "interventionmodel.h"

InterventionModel::InterventionModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

int InterventionModel::rowCount(const QModelIndex &) const {
    return m_interventions.count();
}

QVariant InterventionModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid()) return {};

    const Intervention &i = m_interventions[index.row()];

    switch (role) {
    case IdRole: return i.id;
    case AdresseRole: return i.adresse;
    case TypeRole: return i.type;
    case GraviteRole: return i.gravite;
    case DateRole: return i.date;
    case HeureRole: return i.heure;
    case StatutRole: return i.statut;
    case VictimesRole: return i.victimes;
    }

    return {};
}

QHash<int, QByteArray> InterventionModel::roleNames() const {
    return {
        { IdRole, "interventionId" },
        { AdresseRole, "adresse" },
        { TypeRole, "type" },
        { GraviteRole, "gravite" },
        { DateRole, "date" },
        { HeureRole, "heure" },
        { StatutRole, "statut" },
        { VictimesRole, "victimes" }
    };
}

void InterventionModel::chargerDepuisBDD()
{
    beginResetModel();
    m_interventions.clear();

    QSqlQuery query("SELECT * FROM interventions");

    while (query.next()) {
        m_interventions.append({
            query.value("id").toInt(),
            query.value("adresse").toString(),
            query.value("type").toString(),
            query.value("gravite").toString(),
            query.value("date").toString(),
            query.value("heure").toString(),
            query.value("statut").toString(),
            query.value("victimes").toInt()
        });
    }

    endResetModel();
}
