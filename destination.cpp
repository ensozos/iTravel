#include "destination.h"

Destination::Destination(QString name, QString imPath, QString desc ,quint16 score , QDate date)
{
    this->name = name;
    this->imgPath = imPath;
    this->desc = desc;
    this->date = date;
    this->score = score;
}
