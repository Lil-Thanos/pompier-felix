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
    Q_INVOKABLE void        preparerEnregistrementBDD();



signals:
    void        distanceMinCalculee(QString distance);
    void        messageInfo(QString message);
    void        afficherTempsTrajet(QString temps_affichage);

private slots:
    void        getLonLatGeocoding(double lat, double lon, QString code_postal, QString adresse_complete);
    void        calculerDistanceMin();

private:
    FicheUrgence    *ficheUrgence = nullptr;
    Geocoding       *geocoding    = nullptr;

    QList<QMap<QString, QVariant>>      m_casernes;

    double          m_latitude   = 0.0;
    double          m_longitude  = 0.0;
    QString         m_codepostal;
    QString         m_adresse;

    QStringList     m_type_intervention_tab;
    QString         m_gravite;
    QString         m_type_intervention;
    QString         r_caserne_assigne;

    QDateTime       m_dateHeure;
    QString         r_date;
    QString         r_heure;
    QString         m_commentaire;

    int             m_victimes;

    void        creerFicheUrgence(double latitude, double longitude);
    void        calculerTrajet();

};

#endif
