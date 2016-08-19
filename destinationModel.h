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
        ImgPathRole, DescriptionRole,DateRole,ScoreRole
    };
    QHash<int, QByteArray> roleNames() const;

    DestinationModel();

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    void insertDestination(QString name,QString imPath,QString desc,quint16 score,QDate date);
    void deleteDestination(int index);
    bool isDuplicateDestination(QString name,QString imPath);
    void editDestinationScore(int index,quint16 score);
    void editDestination(int index,QString name,QString imPath,QString desc,QDate date);
    void loadModel();
    void saveModel();

private:
    vector<Destination> myDestinationData;
};

#endif // DESTINATIONMODEL_H
