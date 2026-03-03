#include <QTcpServer>
#include <QTcpSocket>

#include <QJsonObject>
#include <QJsonDocument>
#include <QMap>

#ifdef _WIN32
#include <winsock2.h>
#include <ws2tcpip.h>
#else
#include <arpa/inet.h>
#endif

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

private:
    QTcpServer *server;
    QMap<QTcpSocket*, QByteArray> buffers;

    const int _PORT_SERVER = 45895;

private slots:

    void        nouvelleConnexion();
    void        recevoirJSON();

    void        connexionBDD();
    void        enregistrementBDD();

};
