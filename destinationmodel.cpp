#include "destinationModel.h"
#include <iostream>

DestinationModel::DestinationModel()
{
    Destination greece("Greece","images/images/greece.jpg","mpla mpla mpla mpla","9/9/16");
    Destination rio("Rio","images/images/brazil.jpg","mpla mpla mpla mpla","10/9/16");
    Destination new_york("New York","images/images/newyork.jpg","mpla mpla mpla mpla","6/9/16");

    myDestinationData.push_back(greece);
    myDestinationData.push_back(rio);
    myDestinationData.push_back(new_york);
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

void DestinationModel::insertDestionation(QString name, QString imPath, QString desc, QString date)
{
    beginResetModel();

    Destination *destination_obj;
    destination_obj = new Destination(name,imPath,desc,date);
    this->myDestinationData.push_back(*destination_obj);

    endResetModel();
}

void DestinationModel::deleteDestination(QString name,QString imPath,QString desc,QString date)
{
    beginResetModel();
    Destination *destination_obj;
    destination_obj = new Destination(name,imPath,desc,date);

    //Linear search over all destinations
    int i=0;
    bool found = false;
    vector<Destination>::iterator it;
    for(it = this->myDestinationData.begin(); it != this->myDestinationData.end(); ++it) {
        cout << "Checking index:" << i << endl;
        if(destination_obj->getName() == it->getName()){
            if(destination_obj->getDesc() == it->getDesc()){
                if(destination_obj->getDate() == it->getDate()){
                    if(destination_obj->getImgPath() == it->getImgPath()){
                        found = true;
                        cout << "Found at:" << i <<endl;
                        break;//Breaks the loop
                    }
                }
            }
        }
        i++;
    }
    if(found){
        cout << "Deleting item ...";
        this->myDestinationData.erase(it);
    }else{
        cout << "Item not found. (This should never happen)";
    }
    endResetModel();
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
