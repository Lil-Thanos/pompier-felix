#ifndef SUPERVISEUROPE_H
#define SUPERVISEUROPE_H

#include <QObject>
#include <QList>
#include <QMap>
#include <QVariant>
#include <QDebug>
#include <QDateTime>

#include "src/ficheurgence.h"
#include "src/geocoding.h"

class SuperviseurOPE : public QObject
{
    Q_OBJECT

public:
    explicit SuperviseurOPE(QObject *parent = nullptr);
    ~SuperviseurOPE();

    Q_INVOKABLE void        getAdresse(QString rue);
    Q_INVOKABLE void        getType(QString type_intervention);
    Q_INVOKABLE void        getGravite(int niveau_gravite);
    Q_INVOKABLE void        getNbVictime(int nb_victime);

    Q_INVOKABLE void        getCommentaire(QString commentaire);
    Q_INVOKABLE void        getHeure(QString date, QString heure);

    Q_INVOKABLE void        recalculerDistance();

signals:
    void        distanceMinCalculee(QString distance);
    void        messageInfo(QString message);

private slots:
    void        getLonLatGeocoding(double lat, double lon, QString code_postal);
    void        calculerDistanceMin();

private:
    FicheUrgence    *ficheUrgence = nullptr;
    Geocoding       *geocoding    = nullptr;

    QList<QMap<QString, QVariant>>      m_casernes;

    double          m_latitude   = 0.0;
    double          m_longitude  = 0.0;
    QString         m_codepostal;

    QStringList     m_type_intervention;
    QString         m_gravite;

    QDateTime       m_dateHeure;

    void creerFicheUrgence(double latitude, double longitude);
};

#endif
