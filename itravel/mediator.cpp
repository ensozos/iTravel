#include "mediator.h"
#include "iostream"

Mediator::Mediator(QObject *parent):QObject(parent)
{
    _destinationModel = new DestinationModel();
}

void Mediator::insertDestination(QString name,QString imPath,QString desc,quint16 score,QDate date, QList<QUrl> photos,QString questions)
{
    _destinationModel->insertDestination(name,imPath,desc,score,questions,date,photos);
}

void Mediator::deleteDestination(int index)
{
    _destinationModel->deleteDestination(index);
}

bool Mediator::isDuplicateDestination(QString name,QString imPath,int myIndex)
{
    return _destinationModel->isDuplicateDestination(name,imPath, myIndex);
}

void Mediator::editDestinationScore(int index,quint16 score)
{
    _destinationModel->editDestinationScore(index,score);
}
void Mediator::editDestinationQuestions(int index,QString questions)
{
    _destinationModel->editDestinationQuestions(index,questions);
}

void Mediator::editDestination(int index,QString name,QString imPath,QString desc,QDate date)
{
    _destinationModel->editDestination(index,name,imPath,desc,date);
}

void Mediator::saveAll()
{
    _destinationModel->saveModel();
}

void Mediator::setPhotoAlbum(int index, QList<QUrl> photos){
    _destinationModel->setPhotoAlbum(index,photos);
}

void Mediator::updateTotalScore(int oldScoreOfThisDest, int newScoreOfThisDest){
    _destinationModel->updateTotalScore(oldScoreOfThisDest,newScoreOfThisDest);
}

int Mediator::getTotalScore(){
    return _destinationModel->getTotalScore();
}

