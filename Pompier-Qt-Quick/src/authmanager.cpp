#include "authmanager.h"
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>

AuthManager::AuthManager(QObject *parent) : QObject(parent)
{
    m_networkManager = new QNetworkAccessManager(this);
}

void AuthManager::setLoading(bool value)
{
    if (m_loading == value) return;
    m_loading = value;
    emit loadingChanged();
}

void AuthManager::login(const QString &username, const QString &password)
{
    if (username.trimmed().isEmpty() || password.isEmpty()) {
        emit loginFailed("Remplissez tous les champs");
        return;
    }

    setLoading(true);

    QJsonObject body;
    body["username"] = username.trimmed();
    body["password"] = password;

    QNetworkRequest request(QUrl("http://172.20.15.5:3000/api/login"));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QNetworkReply *reply = m_networkManager->post(
        request,
        QJsonDocument(body).toJson()
        );

    connect(reply, &QNetworkReply::finished,
            this,  [this, reply]() { onReplyFinished(reply); });
}

void AuthManager::onReplyFinished(QNetworkReply *reply)
{
    setLoading(false);

    if (reply->error() != QNetworkReply::NoError) {
        emit loginFailed("Serveur inaccessible : " + reply->errorString());
        reply->deleteLater();
        return;
    }

    QJsonObject obj = QJsonDocument::fromJson(reply->readAll()).object();
    int httpCode    = reply->attribute(
                            QNetworkRequest::HttpStatusCodeAttribute
                            ).toInt();
    reply->deleteLater();

    if (httpCode == 200 && obj["success"].toBool()) {
        m_username = obj["username"].toString();
        m_token    = obj["token"].toString();
        emit usernameChanged();
        emit tokenChanged();
        emit loginSuccess();      // ← Le QML écoutera ça pour switcher
    } else {
        QString msg = obj["message"].toString();
        emit loginFailed(msg.isEmpty() ? "Erreur inconnue" : msg);
    }
}