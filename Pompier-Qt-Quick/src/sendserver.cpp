#include "sendserver.h"

SendServer::SendServer()
{
}

SendServer::~SendServer() {}

void SendServer::send_packet(QString ip,int port, int serverID, QByteArray payload_data)
{
    QTcpSocket tmpSocket(nullptr);

    tmpSocket.connectToHost(ip, port);
    if (!tmpSocket.waitForConnected(3000)) {
        qDebug() << "Impossible de se connecter à" << ip << ":" << port;
        return;
    }

    HeaderPacket header;
    header.size = htonl(payload_data.size());
    header.type = htons(1);
    header.server_id = htons(serverID);

    QByteArray packet;
    packet.append(reinterpret_cast<char*>(&header), sizeof(HeaderPacket));
    packet.append(payload_data);

    // Envoie
    socket->write(packet);
    socket->flush();

    tmpSocket.disconnectFromHost();
}
