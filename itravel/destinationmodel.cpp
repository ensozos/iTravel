#include "destinationModel.h"
#include <iostream>
#include <QFile>
#include <QStandardPaths>
#include <QTextStream>

DestinationModel::DestinationModel()
{
    totalScore = 0;
    loadModel();
}

QHash<int, QByteArray> DestinationModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[DescriptionRole] = "desc";
    roles[ImgPathRole] = "image";
    roles[DateRole] = "date";
    roles[ScoreRole] = "score";
    roles[PhotoAlbumRole] = "photoAlbum";
    roles[QuestionsRole] = "questions";
    return roles;
}
int DestinationModel::rowCount(const QModelIndex &parent) const
{
    return myDestinationData.size();
}

/** Updates the total score given the old and new value of a destination's score. */
void DestinationModel::updateTotalScore(int oldScoreOfThisDest, int newScoreOfThisDest){

    totalScore = totalScore - oldScoreOfThisDest + newScoreOfThisDest;
}

void DestinationModel::loadModel(){

    cout<<"<<Load model>>"<<endl;
    QString s ="data.txt";
    qDebug(s.toLatin1());
    QFile qf(s);
    qf.open(QIODevice::ReadOnly | QIODevice::Text);
    QTextStream in(&qf);
    if(!in.atEnd()){
        totalScore = in.readLine().toInt();
    }
    while (!in.atEnd())
    {
        QString name = in.readLine();
        QString imgPath = in.readLine();
        QString line = in.readLine();
        QString desc;

        if(line != ""){
            desc = line;
            while ((line = in.readLine()) != "" )
            {
                desc.append('\n'+line);
            }
        }else{
            desc = "";
        }
        quint16 score = in.readLine().toInt();
        QString questions = in.readLine();
        QDate date = QDate::fromString(in.readLine(),"ddd dd MMM yyyy");

        QStringList urlStrings = in.readLine().split( "|" );
        urlStrings.removeLast();//It is an empty string due to the "saveModel()" loop.
        QList<QUrl> photos = QList<QUrl>();
        photos = QUrl::fromStringList(urlStrings);

        //Print photo album
        for (QList<QUrl>::iterator i = photos.begin();i != photos.end(); ++i) {
            cout << "Read:" << i->toString().toStdString() << endl;
        }

        insertDestination(name,imgPath,desc,score,questions,date,photos);
    }
    qf.close();
}

void DestinationModel::saveModel(){

    cout<<"<<Save model>>"<<endl;
    QString s ="data.txt";
    QFile qf(s);
    QTextStream out(&qf);
    qf.open(QIODevice::WriteOnly | QIODevice::Text);

    out << totalScore << endl;

    //Linear pass over all destinations
    vector<Destination>::iterator it;
    for(it = this->myDestinationData.begin(); it != this->myDestinationData.end(); ++it) {
        out<< it->getName()    <<endl;
        out<< it->getImgPath() <<endl;
        if(!it->getDesc().isEmpty()){
            out<< it->getDesc().trimmed() << endl <<endl;
        }else{
            out << endl;
        }
        out<< it->getScore()   <<endl;
        out<< it->getQuestions()   <<endl;
        out<< it->getDate().toString("ddd dd MMM yyyy") <<endl;

        QList<QUrl> album = it->getPhotoAlbum();
        if(!album.isEmpty()){
            //Save the photo album as a csv line.
            for (QList<QUrl>::iterator i = album.begin();i != album.end(); ++i) {
                out << i->toString().toUtf8() << "|";
            }
            out << endl;
        }else{
            out << endl;
        }
    }
    qf.close();
}

void DestinationModel::insertDestination(QString name, QString imPath, QString desc,quint16 score,QString questions, QDate date,QList<QUrl> photos)
{
    beginResetModel();

    Destination *destination_obj;
    destination_obj = new Destination(name,imPath,desc,score,date,photos,questions);
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

void DestinationModel::editDestinationScore(int index,quint16 score){
    beginResetModel();
    int size = this->myDestinationData.size();
    if(index>-1 && index<size){
        this->myDestinationData[index].setScore(score);
    }
    endResetModel();
}

/** Appends every element of the "photos" parameter to the photoAlbum of the destination that is stored at "index" inside the model's vector. */
void DestinationModel::setPhotoAlbum(int index, QList<QUrl> photos){

    beginResetModel();
    int size = this->myDestinationData.size();
    if(index>-1 && index<size){
        this->myDestinationData[index].setPhotoAlbum(photos);
    }
    endResetModel();
}

void DestinationModel::editDestination(int index,QString name,QString imPath,QString desc,QDate date){

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

void DestinationModel::editDestinationQuestions(int index, QString questions)
{
    beginResetModel();
    int size = this->myDestinationData.size();
    if(index>-1 && index<size){
        this->myDestinationData[index].setQuestions(questions);
    }
    endResetModel();
}

/** Checks weather a Destination (different from "myIndex") with the specific (name,imgPath) values exists in the model. */
bool DestinationModel::isDuplicateDestination(QString name,QString imgPath, int myIndex){

    //Extract the imageName from the imgPath
    QStringList tokens = imgPath.split( QRegExp("/") ); //Tokenize the imgPath using "/" as a delimiter (applies to Unix paths and Windows URI paths which covers our file paths)
    QString img1Name = tokens.value( tokens.length() - 1 );
    QString img2Name;

    //Linear search over all destinations
    vector<Destination>::iterator it;
    int i=0;
    for(it = this->myDestinationData.begin(); it != this->myDestinationData.end(); ++it, i++) {

        if(name == it->getName()){
            //Extract the imageName
            tokens = it->getImgPath().split( QRegExp("/") );
            img2Name = tokens.value( tokens.length() - 1 );
            if(img1Name == img2Name){
                if(i != myIndex){ //Don't find yourself as a duplicate!
                    return true;
                }
            }
        }
    }
    return false;
}

QVariant DestinationModel::data(const QModelIndex &index, int role) const
{
    int row = index.row();
    if ((int)myDestinationData.size()>row && row>=0)
    {
        Destination i = myDestinationData[row];
        switch (role)
        {
        case NameRole: return i.getName();
        case ImgPathRole: return i.getImgPath();
        case DescriptionRole: return i.getDesc();
        case ScoreRole: return i.getScore();
        case QuestionsRole: return i.getQuestions();
        case DateRole: return i.getDate();
        case PhotoAlbumRole:    return QVariant::fromValue(i.getPhotoAlbum());
        default: return QVariant();
        }
    }
    else
    {
        QVariant qv;
        return qv;
    }
}
