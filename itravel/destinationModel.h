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
        ImgPathRole, DescriptionRole,DateRole,ScoreRole,PhotoAlbumRole,QuestionsRole
    };
    QHash<int, QByteArray> roleNames() const;

    DestinationModel();

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    void insertDestination(QString name,QString imPath,QString desc,quint16 score,QString questions,QDate date,QList<QUrl> photos);
    void deleteDestination(int index);
    bool isDuplicateDestination(QString name,QString imPath, int myIndex);
    void editDestinationScore(int index,quint16 score);
    void editDestination(int index,QString name,QString imPath,QString desc,QDate date);
    void editDestinationQuestions(int index,QString questions);
    void setPhotoAlbum(int index, QList<QUrl> photos);
    void loadModel();
    void saveModel();
    void updateTotalScore(int oldScoreOfThisDest, int newScoreOfThisDest);
    int getTotalScore(){return totalScore;}

private:
    vector<Destination> myDestinationData;
    int totalScore;
};

#endif // DESTINATIONMODEL_H
