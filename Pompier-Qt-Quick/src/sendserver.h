#ifndef SENDSERVER_H
#define SENDSERVER_H

#include <QObject>
#include <QTcpSocket>
#include <QSqlDatabase>
#include <QSqlQuery>

#ifdef _WIN32
#include <winsock2.h>
#include <ws2tcpip.h>
#else
#include <arpa/inet.h>
#endif

#include <QTcpSocket>
#include <QByteArray>
#include <QDebug>

#pragma pack(push, 1)
struct HeaderPacket {
    uint32_t size;
    uint16_t type;
    uint16_t server_id;
};
#pragma pack(pop)

class SendServer
{
public:
    SendServer();
    ~SendServer();

    void        send_packet(QString ip,int port, int serverID,  QByteArray payload_data);

private:
    QTcpSocket  *socket = nullptr;

};

#endif // SENDSERVER_H
