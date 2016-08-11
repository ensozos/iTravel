#ifndef DESTINATION_H
#define DESTINATION_H
#include <QObject>

using namespace std;

class Destination
{
private:
    QString name;
    QString imgPath;
    QString desc;
    QString date;

public:
    Destination(QString name, QString imPath, QString desc, QString date);
    QString getName(){return name;}
    QString getImgPath(){return imgPath;}
    QString getDesc(){return desc;}
    QString getDate(){return date;}

};

#endif // DESTINATION_H
