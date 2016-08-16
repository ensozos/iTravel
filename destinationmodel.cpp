#include "destinationModel.h"
#include <iostream>
#include <QFile>
#include <QStandardPaths>
#include <QTextStream>

DestinationModel::DestinationModel()
{
    /*Destination greece("Greece","images/images/greece.jpg","mpla mpla mpla mpla","9/9/16");
    Destination rio("Rio","images/images/brazil.jpg","mpla mpla mpla mpla","10/9/16");
    Destination new_york("New York","images/images/newyork.jpg","mpla mpla mpla mpla","6/9/16");
    myDestinationData.push_back(greece);
    myDestinationData.push_back(rio);
    myDestinationData.push_back(new_york);*/

    loadModel();
}

QHash<int, QByteArray> DestinationModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[DescriptionRole] = "desc";
    roles[ImgPathRole] = "image";
    roles[DateRole] = "date";

    return roles;
}
int DestinationModel::rowCount(const QModelIndex &parent) const
{
    return myDestinationData.size();
}

void DestinationModel::loadModel(){

    cout<<"<<Load model>>"<<endl;
    QString s ="data.txt";
    qDebug(s.toLatin1());
    QFile qf(s);
    qf.open(QIODevice::ReadOnly | QIODevice::Text);
    QTextStream in(&qf);
    while (!in.atEnd())
    {
        QString name = in.readLine();
        QString imgPath = in.readLine();
        QString desc = in.readLine();
        QString date = in.readLine();
        insertDestination(name,imgPath,desc,date);
    }
    qf.close();
}

void DestinationModel::saveModel(){

    cout<<"<<Save model>>"<<endl;
    QString s ="data.txt";
    QFile qf(s);
    QTextStream out(&qf);
    qf.open(QIODevice::WriteOnly | QIODevice::Text);

    //Linear pass over all destinations
    vector<Destination>::iterator it;
    for(it = this->myDestinationData.begin(); it != this->myDestinationData.end(); ++it) {
        out<< it->getName()    <<endl;
        out<< it->getImgPath() <<endl;
        out<< it->getDesc()    <<endl;
        out<< it->getDate()    <<endl;
    }
    qf.close();
}

void DestinationModel::insertDestination(QString name, QString imPath, QString desc, QString date)
{
    beginResetModel();

    Destination *destination_obj;
    destination_obj = new Destination(name,imPath,desc,date);
    this->myDestinationData.push_back(*destination_obj);

    endResetModel();
}

void DestinationModel::deleteDestination(int index)
{
    beginResetModel();
    vector<Destination>::iterator it = this->myDestinationData.begin();
    advance(it, index);
    //Index should never be -1 but qml might return -1
    if(index != -1){
        this->myDestinationData.erase(it);
    }
    endResetModel();
}

void DestinationModel::editDestination(int index,QString name,QString imPath,QString desc,QString date){

    beginResetModel();
    /*vector<Destination>::size_type*/int size = this->myDestinationData.size();
    if(index>-1 && index<size){
        this->myDestinationData[index].setName(name);
        this->myDestinationData[index].setImgPath(imPath);
        this->myDestinationData[index].setDesc(desc);
        this->myDestinationData[index].setDate(date);
    }
    endResetModel();
}

/** Checks weather a Destination with the specific (name,imgPath) values exists in the model. */
bool DestinationModel::isDuplicateDestination(QString name,QString imgPath){

    //Extract the imageName from the imgPath
    QStringList tokens = imgPath.split( QRegExp("/") ); //Tokenize the imgPath using "/" as a delimiter (applies to Unix paths and Windows URI paths which covers our file paths)
    QString img1Name = tokens.value( tokens.length() - 1 );
    QString img2Name;

    //Linear search over all destinations
    vector<Destination>::iterator it;
    for(it = this->myDestinationData.begin(); it != this->myDestinationData.end(); ++it) {

        if(name == it->getName()){
            //Extract the imageName
            tokens = it->getImgPath().split( QRegExp("/") );
            img2Name = tokens.value( tokens.length() - 1 );
            if(img1Name == img2Name){
                return true;
            }
        }
    }
    return false;
}

QVariant DestinationModel::data(const QModelIndex &index, int role) const
{
    int row = index.row();
    if (myDestinationData.size()>row && row>=0)
    {
        Destination i = myDestinationData[row];
        switch (role)
        {
        case NameRole: return i.getName();
        case ImgPathRole: return i.getImgPath();
        case DescriptionRole: return i.getDesc();
        case DateRole: return i.getDate();
        default: return QVariant();
        }
    }
    else
    {
        QVariant qv;
        return qv;
    }
}
