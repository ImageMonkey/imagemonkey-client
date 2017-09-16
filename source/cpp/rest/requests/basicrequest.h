#ifndef BASIC_REQUEST_H
#define BASIC_REQUEST_H

#include <QObject>
#include "sslrequest.h"

class BasicRequest : public SslRequest{
    Q_OBJECT
    Q_PROPERTY(QString baseUrl READ getBaseUrl WRITE setBaseUrl NOTIFY baseUrlChanged)
    Q_PROPERTY(int requestId READ getRequestId WRITE setRequestId NOTIFY requestIdChanged)
public:
    BasicRequest(const QString& baseUrl, const quint16& requestId);
    BasicRequest();
    Q_INVOKABLE void setBaseUrl(const QString& baseUrl);
    QString getBaseUrl() const;
    Q_INVOKABLE void setRequestId(const quint16 requestId);
    quint16 getRequestId() const;
    ~BasicRequest();
protected:
    QString m_baseUrl;
    quint16 m_requestId;
signals:
    void baseUrlChanged();
    void requestIdChanged();
};

#endif /*BASIC_REQUEST_H*/
