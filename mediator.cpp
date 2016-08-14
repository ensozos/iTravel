#include "mediator.h"

Mediator::Mediator(QObject *parent):QObject(parent)
{
    _destionationModel = new DestinationModel();

}

void Mediator::insertDestination(QString name,QString imPath,QString desc,QString date)
{
    _destionationModel->insertDestionation(name,imPath,desc,date);
}

void Mediator::deleteDestination(QString name,QString imPath,QString desc,QString date)
{
    _destionationModel->deleteDestination(name,imPath,desc,date);
}

bool Mediator::isDuplicateDestination(QString name,QString imPath)
{
    return _destionationModel->isDuplicateDestination(name,imPath);
}

