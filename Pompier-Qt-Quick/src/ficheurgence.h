#ifndef FICHEURGENCE_H
#define FICHEURGENCE_H

#include <QSqlDatabase>
#include <QSqlQuery>
#include <cmath>
#include <QObject>
#include <QSqlError>

class FicheUrgence : public QObject
{
    Q_OBJECT

public:
    explicit FicheUrgence(QObject *parent = nullptr);


private:
    QSqlDatabase base;

    const double     _R =  6371.0;
    const int        _VITESSE_MOYENNE = 60;
    const double     _KMH_TO_MIN = 60.0;



    double           m_distance;

public:
    FicheUrgence();

    QList<QMap<QString, QVariant>>       recupererCasernesParDepartement(QString departement);

    void       connecterBDD();
    void       deconnecterBDD();
    void       connexionBDDSatut();
    void       enregistrerIntervention(QString _adresse,QString _casernes_assigne, QString _type, QString _gravite, QString _date, QString _heure, int _victimes, QString _commentaire, QString statut);

    QString    calculerListCasernes(QList<QMap<QString, QVariant>> casernes, double latSinistre, double lonSinistre);

    double     calculerHaversine(double longitude_s, double lattitude_s, double longitude_t, double lattitude_t);
    double     calculerTempsTrajet();

signals:
    void       statutBDD(bool ok);


};

#endif // FICHEURGENCE_H

