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


public:
    FicheUrgence();

    QList<QMap<QString, QVariant>>       recupererCasernesParDepartement(QString departement);

    void       connecterBDD();
    void       deconnecterBDD();

    QString    calculerListCasernes(QList<QMap<QString, QVariant>> casernes, double latSinistre, double lonSinistre);

    double     calculerHaversine(double longitude_s, double lattitude_s, double longitude_t, double lattitude_t);


};

#endif // FICHEURGENCE_H

