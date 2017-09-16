#include "basicrequest.h"
#include "../settings.h"

BasicRequest::BasicRequest()
    : SslRequest(),
      m_requestId(0)
{
    ConnectionSettings* connectionSettings = ConnectionSettings::instance();
    if(connectionSettings)
        m_baseUrl = connectionSettings->getBaseUrl();
}

void BasicRequest::setBaseUrl(const QString& baseUrl){
    m_baseUrl = baseUrl;
}

QString BasicRequest::getBaseUrl() const{
    return m_baseUrl;
}

void BasicRequest::setRequestId(const quint16 requestId){
    m_requestId = requestId;
    m_request->setRawHeader(QByteArray("X-Request-Type"), QString::number(requestId).toUtf8());
}

quint16 BasicRequest::getRequestId() const{
    return m_requestId;
}

BasicRequest::BasicRequest(const QString &baseUrl, const quint16& requestId)
    : SslRequest(),
      m_baseUrl(baseUrl),
      m_requestId(requestId)
{
    m_request->setRawHeader(QByteArray("X-Request-Type"), QString::number(requestId).toUtf8());
}

BasicRequest::~BasicRequest(){
}
