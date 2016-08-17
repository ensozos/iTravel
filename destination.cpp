#include "destination.h"

Destination::Destination(QString name, QString imPath, QString desc, QDate date)
{
    this->name = name;
    this->imgPath = imPath;
    this->desc = desc;
    this->date = date;
}
