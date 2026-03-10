#include <QCoreApplication>

#include "servertcp.h"

#define _PORT_SERVER 45895

void affichageServer()
{
    std::cout << "+======================================================+" << std::endl;
    std::cout << "|         Server Caserne Pompier Felix                 |" << std::endl;
    std::cout << "+======================================================+" << std::endl;
    std::cout << std::endl;
    // std::cout << "[-] Attente de connexion..." << std::endl;
}

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    ServerTcp server;

    affichageServer();

    // 2. BDD
    server.connexionBDD();

    // 3. Écoute TCP
    server.demarrer();

    return a.exec();
}
