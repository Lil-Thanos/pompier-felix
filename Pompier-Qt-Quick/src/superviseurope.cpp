#include "superviseurope.h"

SuperviseurOPE::SuperviseurOPE(QObject *parent)
    : QObject(parent)
{
    ficheUrgence = new FicheUrgence(this);
    geocoding    = new Geocoding(this);

    ficheUrgence->connecterBDD();

    connect(geocoding, &Geocoding::coordonneesRecues,
            this, &SuperviseurOPE::getLonLatGeocoding);
}

SuperviseurOPE::~SuperviseurOPE()
{
    if (ficheUrgence) {
        ficheUrgence->deconnecterBDD();
    }
}

void SuperviseurOPE::getAdresse(QString rue)
{
    //QString fullAdresse = nbRue + "+" + nomRue + "+" + zipCode;
    //fullAdresse.replace(" ", "+");

    QString fullAdresse = rue;
    fullAdresse.replace(" ", "+");

    qDebug() << "Adresse complète :" << fullAdresse;

    geocoding->obtenirCoordonnees(fullAdresse);
}

void SuperviseurOPE::getLonLatGeocoding(double lat, double lon, QString code_postal)
{
    m_latitude   = lat;
    m_longitude  = lon;
    m_codepostal = code_postal;

    creerFicheUrgence(lat, lon);

    m_casernes = ficheUrgence->recupererCasernesParDepartement(m_codepostal);

    if (!m_casernes.isEmpty()) {
        calculerDistanceMin();
    } else {
        emit messageInfo("Aucune caserne trouvée");
    }
}

void SuperviseurOPE::creerFicheUrgence(double latitude, double longitude)
{
    qDebug() << "Latitude:" << latitude << "Longitude:" << longitude;
}

void SuperviseurOPE::calculerDistanceMin()
{
    if (m_casernes.isEmpty()) {
        emit messageInfo("Veuillez d'abord rechercher une adresse");
        return;
    }

    QString mindist = ficheUrgence->calculerListCasernes(m_casernes,m_latitude, m_longitude);

    emit distanceMinCalculee(mindist);
}

void SuperviseurOPE::recalculerDistance()
{
    creerFicheUrgence(m_latitude, m_longitude);
}
