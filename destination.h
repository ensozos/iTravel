#ifndef DESTINATION_H
#define DESTINATION_H
#include <QObject>
#include <QDate>

using namespace std;

class Destination
{
private:
    QString name;
    QString imgPath;
    QString desc;
    QDate date;

public:
    Destination(QString name, QString imPath, QString desc, QDate date);
    QString getName(){return name;}
    QString getImgPath(){return imgPath;}
    QString getDesc(){return desc;}
    QDate getDate(){return date;}

    void setName(QString n){name = n;}
    void setImgPath(QString i){imgPath = i;}
    void setDesc(QString d){desc = d;}
    void setDate(QDate d){date = d;}

};

#endif // DESTINATION_H
