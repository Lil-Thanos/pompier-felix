#ifndef AUTHMANAGER_H
#define AUTHMANAGER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>

class AuthManager : public QObject
{
    Q_OBJECT

    // Ces trois propriétés sont lisibles directement dans le QML
    Q_PROPERTY(QString username READ username NOTIFY usernameChanged)
    Q_PROPERTY(QString token    READ token    NOTIFY tokenChanged)
    Q_PROPERTY(bool    loading  READ loading  NOTIFY loadingChanged)

public:
    explicit AuthManager(QObject *parent = nullptr);

    QString username() const { return m_username; }
    QString token()    const { return m_token;    }
    bool    loading()  const { return m_loading;  }

    // Appelable depuis le QML : authManager.login(user, pass)
    Q_INVOKABLE void login(const QString &username, const QString &password);

signals:
    void loginSuccess();
    void loginFailed(QString message);
    void usernameChanged();
    void tokenChanged();
    void loadingChanged();

private slots:
    void onReplyFinished(QNetworkReply *reply);

private:
    QNetworkAccessManager *m_networkManager;
    QString m_username;
    QString m_token;
    bool    m_loading = false;

    void setLoading(bool value);
};

#endif