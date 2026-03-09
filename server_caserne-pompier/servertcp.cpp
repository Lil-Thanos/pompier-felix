#include "servertcp.h"

ServerTcp::ServerTcp(QObject *parent) : QObject(parent)
{
    server = new QTcpServer(this);

    connect(server, &QTcpServer::newConnection, this, &ServerTcp::nouvelleConnexion);


}

void ServerTcp::nouvelleConnexion()
{
    QTcpSocket *clientSocket = server->nextPendingConnection();

    buffers[clientSocket] = QByteArray();

    connect(clientSocket, &QTcpSocket::readyRead, this, &ServerTcp::recevoirJSON);

    connect(clientSocket, &QTcpSocket::disconnected, this, [=](){buffers.remove(clientSocket); clientSocket->deleteLater();});

    QString ipPort = clientSocket->peerAddress().toString() + ":" + QString::number(clientSocket->peerPort());

    std::cout << "[+] Nouvelle connexion: " << ipPort.toStdString() << std::endl;
}

void ServerTcp::recevoirJSON()
{
    QTcpSocket *clientSocket = qobject_cast<QTcpSocket*>(sender());
    if (!clientSocket)
        return;

    // Ajouter les nouvelles données au buffer
    buffers[clientSocket].append(clientSocket->readAll());

    QByteArray &buffer = buffers[clientSocket];

    while (true)
    {
        // Vérifier header complet
        if (buffer.size() < sizeof(HeaderPacket))
            return;

        HeaderPacket header;
        memcpy(&header, buffer.constData(), sizeof(HeaderPacket));

        uint32_t size = ntohl(header.size);
        uint16_t type = ntohs(header.type);
        uint16_t server_id = ntohs(header.server_id);

        // vérifier payload complet
        if (buffer.size() < sizeof(HeaderPacket) + size)
            return;

        // extraire JSON
        QByteArray jsonData = buffer.mid(sizeof(HeaderPacket), size);

        // Supprimer header + payload du buffer
        buffer.remove(0, sizeof(HeaderPacket) + size);

        std::cout << "[*] Header reçu:"<< "size=" << size << "type=" << type << "server_id=" << server_id << std::endl;

        // parser JSON
        QJsonDocument doc = QJsonDocument::fromJson(jsonData);
        if (!doc.isObject()) {
            std::cout << "[X] JSON invalide" << std::endl;
            continue;
        }

        QJsonObject obj = doc.object();

        QString sType        = obj["type"].toString();
        QString sAdresse     = obj["adresse"].toString();
        int     iGravite     = obj["gravite"].toInt();
        int     iVictimes    = obj["victimes"].toInt();
        QString sCommentaire = obj["commentaire"].toString();

        QString sDate        = obj["date"].toString();
        QString sHeure       = obj["heure"].toString();

        std::cout << "[*] Intervention reçue: "
                  << obj["type"].toString().toStdString() << " | "
                  << obj["adresse"].toString().toStdString() << " | "
                  << obj["gravite"].toInt() << " | "
                  << obj["victimes"].toInt() << " | "
                  << obj["commentaire"].toString().toStdString() << " | "
                  << obj["date"].toString().toStdString() << " | "
                  << obj["heure"].toString().toStdString()
                  << std::endl;

        enregistrementBDD(sType, sAdresse, iGravite, iVictimes, sCommentaire, sDate, sHeure, server_id);


    }
}

bool ServerTcp::connexionBDD()
{
    db = QSqlDatabase::addDatabase("QMYSQL");
    db.setHostName("localhost");
    db.setDatabaseName("secours");
    db.setUserName("alerte");
    db.setPassword("motdepassealerte");

    if (!db.open()) {
        std::cout << "[X] Erreur connexion BDD : " << db.lastError().text().toStdString() << std::endl;
        return false;
    }
    std::cout << "[+] BDD connectée : " << db.hostName().toStdString() << " / " << db.databaseName().toStdString() << std::endl;
    return true;
}

void ServerTcp::demarrer()
{
    server->listen(QHostAddress::Any, _PORT_SERVER);
    std::cout << "[-] Ecoute sur le port : " << _PORT_SERVER << std::endl;
    std::cout << "[-] Attente de connexion..." << std::endl;
}


void ServerTcp::enregistrementBDD(const QString& type, const QString& adresse, int gravite, int victimes, const QString& commentaire, const QString& date, const QString& heure, uint16_t server_id)
{
    QString reqSQL =
        "INSERT INTO alerte (type, adresse, gravite, victimes, commentaire, date, heure, server_id) "
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    QSqlQuery sql(db);

    if(!sql.prepare(reqSQL))
    {
        std::cout << "[X] Erreur prepare : " << sql.lastError().text().toStdString() << std::endl;
        return;
    }

    // conversion date
    QDate dateObj = QDate::fromString(date, "dd/MM/yyyy");
    QTime timeObj = QTime::fromString(heure, "HH:mm");

    QString mysqlDate = dateObj.toString("yyyy-MM-dd");
    QString mysqlTime = timeObj.toString("HH:mm:ss");

    std::cout << "[*] Date convertie : " << mysqlDate.toStdString() << std::endl;
    std::cout << "[*] Heure convertie : " << mysqlTime.toStdString() << std::endl;

    sql.addBindValue(type);
    sql.addBindValue(adresse);
    sql.addBindValue(gravite);
    sql.addBindValue(victimes);
    sql.addBindValue(commentaire);
    sql.addBindValue(mysqlDate);
    sql.addBindValue(mysqlTime);
    sql.addBindValue(server_id);

    if(!sql.exec())
    {
        std::cout << "[X] Erreur SQL : " << sql.lastError().text().toStdString() << std::endl;
    }
    else
    {
        std::cout << "[*] Intervention enregistrée en BDD" << std::endl;
    }
}
