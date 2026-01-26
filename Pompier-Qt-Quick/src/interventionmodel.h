#pragma once

#include <QAbstractListModel>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

struct Intervention {
    int id;
    QString adresse;
    QString type;
    QString gravite;
    QString date;
    QString heure;
    QString statut;
    int victimes;
};

class InterventionModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum Roles {
        IdRole = Qt::UserRole + 1,
        AdresseRole,
        TypeRole,
        GraviteRole,
        DateRole,
        HeureRole,
        StatutRole,
        VictimesRole
    };

    explicit InterventionModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void chargerDepuisBDD();

private:
    QList<Intervention> m_interventions;
};
