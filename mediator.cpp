#include "mediator.h"

Mediator::Mediator(QObject *parent):QObject(parent)
{
    _destionationModel = new DestinationModel();

}

void Mediator::insertDestination(QString name,QString imPath,QString desc,QString date)
{
    _destionationModel->insertDestionation(name,imPath,desc,date);
}
