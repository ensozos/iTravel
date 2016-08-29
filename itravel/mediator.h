#ifndef MEDIATOR_H
#define MEDIATOR_H
#include "destinationModel.h"
#include <QObject>


class Mediator : public QObject
{
    Q_OBJECT
    Q_PROPERTY(DestinationModel* destinationModel READ destinationModel WRITE setDestinationModel NOTIFY destinationModelChanged)


public:
    Mediator(QObject *parent=0);
    void setDestinationModel(DestinationModel *model){
        _destinationModel = model;
        emit destinationModelChanged();
    }

    DestinationModel* destinationModel(){
        return _destinationModel;
    }

private:
    DestinationModel *_destinationModel;

signals:
    void destinationModelChanged();
    void scoreSignal(QVariant score);

public slots:
    void insertDestination(QString name,QString imPath,QString desc,quint16 score,QDate date,QList<QUrl> photos,QString questions);
    void deleteDestination(int index);
    bool isDuplicateDestination(QString name,QString imPath, int myIndex);
    void editDestinationScore(int index,quint16 score);
    void editDestinationQuestions(int index,QString questions);
    void editDestination(int index,QString name,QString imPath,QString desc,QDate date);
    void setPhotoAlbum(int index, QList<QUrl> photos);
    void saveAll();
    void updateTotalScore(int oldScoreOfThisDest, int newScoreOfThisDest);
    int getTotalScore();
};

#endif // MEDIATOR_H
