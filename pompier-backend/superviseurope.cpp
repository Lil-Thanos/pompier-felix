#include "superviseurope.h"
#include "./ui_superviseurope.h"

SuperviseurOPE::SuperviseurOPE(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::SuperviseurOPE)
{
    ui->setupUi(this);

    ficheUrgence = new FicheUrgence(this);
    geocoding = new Geocoding(this);


    ficheUrgence->connecterBDD();

    connect(ui->pushButton_calcule, &QPushButton::clicked, this, &SuperviseurOPE::recalculerDistance);
    connect(geocoding, &Geocoding::coordonneesRecues, this, &SuperviseurOPE::getLonLatGeocoding);

    connect(ui->pushButton_adresse, &QPushButton::clicked, this, &SuperviseurOPE::getAdresse);

    connect(ui->pushButton_minDist, &QPushButton::clicked, this, &SuperviseurOPE::calculerDistanceMin);

}

SuperviseurOPE::~SuperviseurOPE()
{
    if (ficheUrgence) {
        ficheUrgence->deconnecterBDD();
    }

    delete ui;
}

void SuperviseurOPE::recalculerDistance()
{
    creerFicheUrgence(m_latitude, m_longitude);
}

void SuperviseurOPE::getLonLatGeocoding(double lat, double lon, QString code_postal) {

    m_latitude   = lat;
    m_longitude  = lon;
    m_codepostal = code_postal;

    creerFicheUrgence(lat, lon);

    qDebug() << m_codepostal << ", " << code_postal;

    m_casernes = ficheUrgence->recupererCasernesParDepartement(m_codepostal);
    qDebug() << "nombre de casernes :" << m_casernes.size();

    if (!m_casernes.isEmpty()) {
        calculerDistanceMin();
    } else {
        ui->label_minDist->setText("Aucune caserne trouvée");
    }
}

void SuperviseurOPE::creerFicheUrgence(double latitude_sinistre, double longitude_sinistre)
{
    if (!ficheUrgence) {
        qDebug() << "Erreur : Fiche urgence non créé.";
        // ui->textEdit_log->setText("Erreur : Fiche urgence non instancié.");
        return;
    }
    qDebug() << "Latitude:" << latitude_sinistre << ", Longitude:" << longitude_sinistre;

    double distance = ficheUrgence->calculerHaversine(longitude_sinistre, latitude_sinistre, -2.8356415, 48.6085464);

    QString strValue = QString::number(distance, 'f', 3);
    ui->lineEdit_test->setText(strValue);
}

void SuperviseurOPE::getAdresse() {
    QString fullAdresse, zipCode, nomRue, nbRue;

    nbRue = ui->lineEdit->text();
    nomRue = ui->lineEdit_2->text();
    zipCode = ui->lineEdit_3->text();

    fullAdresse = nbRue + "+" + nomRue + "+" + zipCode;

    fullAdresse.replace(" ", "+");

    qDebug() << "Adresse complète : " << fullAdresse;


    geocoding->obtenirCoordonnees(fullAdresse);
}


void SuperviseurOPE::calculerDistanceMin()
{
    if (m_casernes.isEmpty()) {
        ui->label_minDist->setText("Veuillez d'abord rechercher une adresse");
        return;
    }

    QString mindist = ficheUrgence->calculerListCasernes(m_casernes, m_latitude, m_longitude);
    ui->label_minDist->setText(mindist);
}

