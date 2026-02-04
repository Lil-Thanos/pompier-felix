#include "superviseurope.h"

SuperviseurOPE::SuperviseurOPE(QObject *parent)
    : QObject(parent)
{
    ficheUrgence = new FicheUrgence(this);
    geocoding    = new Geocoding(this);

    ficheUrgence->connecterBDD();

    connect(geocoding, &Geocoding::coordonneesRecues,this, &SuperviseurOPE::getLonLatGeocoding);
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

void SuperviseurOPE::getType(QString type_intervention)
{
    qDebug() << "Type intervention reçu :" << type_intervention;

    m_type_intervention = type_intervention;

    //m_type_intervention_tab << "incendie" << "accident" << "inondation" << "secoursPersone";
    // 1 = incendie
    // 2 = accident
    // 3 = inondation
    // 4 = secours à la personne

}

void SuperviseurOPE::getGravite(int niveau_gravite)
{

    //qDebug() << "Niveau de gravité reçu : " << niveau_gravite;
    // Reçois deja une valeur entre -1 et 2

    if (niveau_gravite == 0) m_gravite = "Urgence";

    else if (niveau_gravite == 1) m_gravite = "Normal";

    else if (niveau_gravite ==  2) m_gravite = "Faible";

    qDebug() << "Niveau de gravité reçu : " <<  m_gravite;

}

void SuperviseurOPE::getNbVictime(int nb_victime)
{
    qDebug() << "Nombre de victime : " <<  nb_victime;

    m_victimes = nb_victime;

}

void SuperviseurOPE::getCommentaire(QString commentaire)
{
    qDebug() << "Commentaire lié à la fiche urgence : " <<  commentaire;

    m_commentaire = commentaire;

}

void SuperviseurOPE::getHeure(QString date, QString heure)
{
    m_dateHeure = QDateTime::fromString( date + " " + heure, "dd/MM/yyyy HH:mm");
    r_date = date;
    r_heure = heure;

    if (!m_dateHeure.isValid()) {
        qDebug() << "Date/heure invalide";
        return;
    }

    qDebug() << "Date/heure :" << m_dateHeure;
}

void SuperviseurOPE::getLonLatGeocoding(double lat, double lon, QString code_postal, QString adresse_complete)
{
    m_latitude   = lat;
    m_longitude  = lon;
    m_codepostal = code_postal;
    m_adresse    = adresse_complete;

    qDebug() << m_adresse << adresse_complete;

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

    QString mindist = ficheUrgence->calculerListCasernes(m_casernes, m_latitude, m_longitude);
    r_caserne_assigne = mindist;

    emit distanceMinCalculee(mindist);

    calculerTrajet();
    preparerEnregistrementBDD();
}

void SuperviseurOPE::recalculerDistance()
{
    creerFicheUrgence(m_latitude, m_longitude);
}

void SuperviseurOPE::preparerEnregistrementBDD()
{
    QString statut = "en_cours";

    qDebug() << "Enregistrement dans la bdd: " << m_adresse << r_caserne_assigne << m_type_intervention << m_gravite << r_date << r_heure << m_victimes << m_commentaire << statut;

    ficheUrgence->enregistrerIntervention(m_adresse, r_caserne_assigne, m_type_intervention, m_gravite, r_date, r_heure, m_victimes, m_commentaire, statut);

}

void SuperviseurOPE::calculerTrajet()
{
    double temps = ficheUrgence->calculerTempsTrajet();

    QString temps_affichage = "Temps d'intervention : " + QString::number(temps) + " en mins.";

    emit afficherTempsTrajet(temps_affichage);
}
