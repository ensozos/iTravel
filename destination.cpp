#include "destination.h"
#include <iostream>

Destination::Destination(QString name, QString imPath, QString desc ,quint16 score , QDate date, QList<QUrl> photos,QString questions)
{
    this->name = name;
    this->imgPath = imPath;
    this->desc = desc;
    this->date = date;
    this->score = score;
    this->photoAlbum = photos;
    this->questions = questions;

    //Print the photo album list
    //for (QList<QUrl>::iterator i = photos.begin();i != photos.end(); ++i) {cout << "INSERTED:" << i->toString().toStdString() << endl;}
}
