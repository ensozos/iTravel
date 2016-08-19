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
    quint16 score;

public:
    Destination(QString name, QString imPath, QString desc,quint16 score, QDate date);
    QString getName(){return name;}
    QString getImgPath(){return imgPath;}
    QString getDesc(){return desc;}
    QDate getDate(){return date;}
    quint16 getScore(){return score;}

    void setName(QString n){name = n;}
    void setImgPath(QString i){imgPath = i;}
    void setDesc(QString d){desc = d;}
    void setDate(QDate d){date = d;}
    void setScore(quint16 s){score = s;}
};

#endif // DESTINATION_H
