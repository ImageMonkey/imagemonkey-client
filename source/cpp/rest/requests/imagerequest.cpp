#include "imagerequest.h"
#include <QFile>
#include <QUrlQuery>
#include <QUuid>

DonatePictureRequest::DonatePictureRequest()
    : BasicRequest()
{
    QUrl url(m_baseUrl + "donate");
    m_request->setUrl(url);
}

void DonatePictureRequest::set(const QString& path, const QString& label){
    QString uuid = QUuid::createUuid().toByteArray();
    QString boundary = "boundary_.oOo._" + uuid.mid(1,36).toUpper();
    //qDebug() << boundary;
    QByteArray data(QString("--" + boundary + "\r\n").toUtf8());
    data.append("Content-Disposition: form-data; name=\"label\"\r\n\r\n");
    data.append((label + "\r\n"));
    data.append("--" + boundary + "\r\n"); //according to rfc 1867
    data.append("Content-Disposition: form-data; name=\"image\"; filename=\"file.jpg\"\r\n");
    data.append("Content-Type: image/jpeg\r\n\r\n"); //data type
    //QString path1 = "C:\\Users\\Bernhard\\Pictures\\pizza.jpg";
    QString filePath = "";
    QUrl fileUrl(path);
    if(fileUrl.isLocalFile()) filePath = fileUrl.toLocalFile();
    else filePath = path;

    QFile file(filePath);
    if(!file.open(QIODevice::ReadOnly)){
        qDebug() << "Couldn't read image from " << filePath;
        return;
    }
    data.append(file.readAll()); //let's read the file
    data.append("\r\n");
    data.append("--" + boundary + "--\r\n"); //closing boundary according to rfc 1867

    setData(data);

    m_request->setRawHeader(QString("Content-Type").toUtf8(), QString("multipart/form-data; boundary=" + boundary).toUtf8());
    m_request->setRawHeader(QString("Content-Length").toUtf8(), QString::number(data.length()).toUtf8());

}

DonatePictureRequest::~DonatePictureRequest(){
}

GetRandomPictureRequest::GetRandomPictureRequest()
    : BasicRequest()
{
    QUrl url(m_baseUrl + "validate");
    m_request->setUrl(url);
}

GetRandomPictureRequest::~GetRandomPictureRequest(){
}

ValidatePictureRequest::ValidatePictureRequest()
    : BasicRequest()
{
    QUrl url(m_baseUrl + "validate");
    m_request->setUrl(url);
}

void ValidatePictureRequest::set(const QString& id, const bool valid){
    QUrl url(m_baseUrl + "validate/" + id + "/" + ((valid) ? "yes" : "no"));
    m_request->setUrl(url);
}

ValidatePictureRequest::~ValidatePictureRequest(){
}

GetRandomPictureLabelRequest::GetRandomPictureLabelRequest()
    : BasicRequest()
{
    QUrl url(m_baseUrl + "label/random");
    m_request->setUrl(url);
}

GetRandomPictureLabelRequest::~GetRandomPictureLabelRequest(){
}

GetAllPictureLabelsRequest::GetAllPictureLabelsRequest()
    : BasicRequest()
{
    QUrl url(m_baseUrl + "label");
    m_request->setUrl(url);
}

GetAllPictureLabelsRequest::~GetAllPictureLabelsRequest(){
}
