#ifdef _WIN32
#include <winsock2.h>
#include <ws2tcpip.h>
#else
#include <arpa/inet.h>
#endif

#include <iostream>

#include <QTcpServer>
#include <QTcpSocket>

#include <QJsonObject>
#include <QJsonDocument>
#include <QMap>

#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>


#pragma pack(push, 1)

struct HeaderPacket {
    uint32_t size;
    uint16_t type;
    uint16_t server_id;
};

#pragma pack(pop)

class ServerTcp : public QObject
{
    Q_OBJECT

public:
    explicit ServerTcp(QObject *parent = nullptr);

    void        demarrer();
    bool        connexionBDD();

private:
    QTcpServer      *server;
    QSqlDatabase    db;

    QMap<QTcpSocket*, QByteArray> buffers;

    const int       _PORT_SERVER = 45895;
    const QString   _STATUT      = "Reçu";


private slots:

    void        nouvelleConnexion();
    void        recevoirJSON();

    void        enregistrementBDD(const QString& type, const QString& adresse,int gravite, int victimes, const QString& commentaire, const QString& date, const QString& heure, uint16_t server_id);

};
