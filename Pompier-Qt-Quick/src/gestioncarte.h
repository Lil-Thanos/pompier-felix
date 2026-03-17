#pragma once
#include <QObject>
#include <QSqlDatabase>
#include <QVariantList>
#include <QRegularExpression>

struct Intervention_carte {
    int id;
    QString adresse;
    QString type;
    QString gravite;
    QString caserne;
    double lat;
    double lon;
};

class InterventionsManager : public QObject
{
    Q_OBJECT
public:
    explicit InterventionsManager(QObject* parent = nullptr);
    ~InterventionsManager();

    Q_INVOKABLE QVariantList getEnCoursInterventions();

    QString getNomcaserne(QString input);

private:
    QSqlDatabase m_db;
};