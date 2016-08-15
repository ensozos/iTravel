#ifndef DESTINATIONMODEL_H
#define DESTINATIONMODEL_H

#include "destination.h"
#include <QObject>
#include <QAbstractListModel>

using namespace std;
class DestinationModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum DestinationRoles {
        NameRole = Qt::UserRole + 1,
        ImgPathRole, DescriptionRole,DateRole
    };
    QHash<int, QByteArray> roleNames() const;

    DestinationModel();

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    void insertDestionation(QString name,QString imPath,QString desc,QString date);
    void deleteDestination(QString name,QString imPath,QString desc,QString date);

private:
    vector<Destination> myDestinationData;
};

#endif // DESTINATIONMODEL_H
