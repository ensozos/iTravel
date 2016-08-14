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
        _destionationModel = model;
        emit destinationModelChanged();
    }

    DestinationModel* destinationModel(){
        return _destionationModel;
    }

private:
    DestinationModel *_destionationModel;

signals:
    void destinationModelChanged();

public slots:
    void insertDestination(QString name,QString imPath,QString desc,QString date);
    void deleteDestination(QString name,QString imPath,QString desc,QString date);
    bool isDuplicateDestination(QString name,QString imPath);
};

#endif // MEDIATOR_H
