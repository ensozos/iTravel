#ifndef DESTINATION_H
#define DESTINATION_H
#include <QObject>
#include <QDate>
#include <QUrl>

using namespace std;

class Destination
{
private:
    QString name;
    QString imgPath;
    QString desc;
    QDate date;
    quint16 score;
    QList<QUrl> photoAlbum;

public:
    Destination(QString name, QString imPath, QString desc,quint16 score, QDate date, QList<QUrl> photos);
    QString getName(){return name;}
    QString getImgPath(){return imgPath;}
    QString getDesc(){return desc;}
    QDate getDate(){return date;}
    quint16 getScore(){return score;}
    QList<QUrl> getPhotoAlbum(){return photoAlbum;}

    void setName(QString n){name = n;}
    void setImgPath(QString i){imgPath = i;}
    void setDesc(QString d){desc = d;}
    void setDate(QDate d){date = d;}
    void setScore(quint16 s){score = s;}
    void setPhotoAlbum(QList<QUrl> photos){photoAlbum = photos;}
};

#endif // DESTINATION_H
