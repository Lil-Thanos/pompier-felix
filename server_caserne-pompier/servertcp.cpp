#include "servertcp.h"

ServerTcp::ServerTcp(QObject *parent) : QObject(parent)
{
    server = new QTcpServer(this);

    connect(server, &QTcpServer::newConnection, this, &ServerTcp::nouvelleConnexion);

    server->listen(QHostAddress::Any, _PORT_SERVER);
}

void ServerTcp::nouvelleConnexion()
{
    QTcpSocket *clientSocket = server->nextPendingConnection();

    buffers[clientSocket] = QByteArray();

    connect(clientSocket, &QTcpSocket::readyRead, this, &ServerTcp::recevoirJSON);

    connect(clientSocket, &QTcpSocket::disconnected, this, [=](){buffers.remove(clientSocket); clientSocket->deleteLater();});

    qDebug() << "Nouvelle connexion";
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

        qDebug() << "Header reçu:"<< "size=" << size << "type=" << type << "server_id=" << server_id;

        // parser JSON
        QJsonDocument doc = QJsonDocument::fromJson(jsonData);
        if (!doc.isObject()) {
            qDebug() << "JSON invalide";
            continue;
        }

        QJsonObject obj = doc.object();

        qDebug() << "Intervention reçue:" << obj["type"].toString() << obj["adresse"].toString() << obj["gravite"].toInt() << obj["victimes"].toInt() << obj["commentaire"].toString() << obj["date"].toString() << obj["heure"].toString();
    }
}
