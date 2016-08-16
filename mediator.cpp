#include "mediator.h"

Mediator::Mediator(QObject *parent):QObject(parent)
{
    _destionationModel = new DestinationModel();

}

void Mediator::insertDestination(QString name,QString imPath,QString desc,QString date)
{
    _destionationModel->insertDestionation(name,imPath,desc,date);
}

void Mediator::deleteDestination(int index)
{
    _destionationModel->deleteDestination(index);
}

bool Mediator::isDuplicateDestination(QString name,QString imPath)
{
    return _destionationModel->isDuplicateDestination(name,imPath);
}

void Mediator::editDestination(int index,QString name,QString imPath,QString desc,QString date){
    _destionationModel->editDestination(index,name,imPath,desc,date);
}

