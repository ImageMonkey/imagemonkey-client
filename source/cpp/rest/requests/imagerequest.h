#ifndef _IMAGEREQUEST_H_
#define _IMAGEREQUEST_H_

#include "sslrequest.h"
#include "basicrequest.h"

class DonatePictureRequest : public BasicRequest{
    Q_OBJECT
public:
    DonatePictureRequest();
    Q_INVOKABLE void set(const QString& path, const QString& label);
    ~DonatePictureRequest();
};

class GetRandomPictureRequest : public BasicRequest{
    Q_OBJECT
public:
    GetRandomPictureRequest();
    ~GetRandomPictureRequest();
};

class GetRandomPictureLabelRequest : public BasicRequest{
    Q_OBJECT
public:
    GetRandomPictureLabelRequest();
    ~GetRandomPictureLabelRequest();
};

class ValidatePictureRequest : public BasicRequest{
    Q_OBJECT
public:
    ValidatePictureRequest();
    Q_INVOKABLE void set(const QString& id, const bool valid);
    ~ValidatePictureRequest();
};

#endif /*_IMAGEREQUEST_H_*/
