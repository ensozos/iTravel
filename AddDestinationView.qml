import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick 2.2
import QtQuick.Dialogs 1.0

//SUGGESTION: We could have a photo gallery for each destination. (Ex. When we click on "Rio" we see the image,title,date,description and a photo gallery)

Rectangle {

    CustomToolBar{
        id:myToolBar
    }

    Rectangle{
        id: container
        color:"light blue"
        anchors.top: myToolBar.bottom
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: 10
        anchors.topMargin: 10
        width: (parent.width>1000) ? 900 : (parent.width * 0.9) //If the width is <1200 then set is as "90% of parent" else set it as "1080"

        Button{
            id: uploadPhoto
            anchors.left: parent.left
            anchors.top: parent.top
            width: 200
            height:25

            Text{
                text: "Upload Photo"
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
            onClicked: {
                fileDialog.open()
            }
        }

        Image
        {
            id:photo
            anchors.top: uploadPhoto.top
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectFit
            height:0
            width :0
            source:""
        }

        Row{
            id: destinationRow
            anchors.top: uploadPhoto.bottom
            anchors.topMargin: 10
            spacing: 10

            Text{
                anchors.verticalCenter: parent.verticalCenter
                text:"Title:"
            }

            TextField{
                id:title
                placeholderText: "Destination Name"

            }
        }

        Row{
            id: dateRow
            anchors.top: destinationRow.bottom
            anchors.topMargin: 10
            spacing: 10

            Text{
                anchors.verticalCenter: parent.verticalCenter
                text:"Date:"
            }

            TextField{
                id:date
                placeholderText: "Visit Date"

            }
        }

        Column{
            id: descriptionCol
            anchors.top: dateRow.bottom
            anchors.topMargin: 20

            Text{
                text:"Description:"
            }

            TextArea{
                id:description
                width: 400
                height: 200
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            }
        }
    }

    Row{
        id: bottomRow
        anchors.bottom: container.bottom
        anchors.left: container.left
        anchors.bottomMargin: 10
        spacing: 10

        Button{
            text:"cancel"
            onClicked: {
                console.log("Canceled")
                stack.pop()
            }
        }

        Button{
            text:"apply"
            onClicked: {
                console.log("\n----------------------------\nInsert New Destination:"+"\nImage:"+photo.source+"\nTitle:"+title.text+"\nDate:"+date.text+"\nDescription:"+description.text+"\n----------------------------")
                if(photo.source == ""){
                    photo.source = "images/images/noImage.png"
                }
                if(!mediator.isDuplicateDestination(title.text,photo.source)){
                    mediator.insertDestination(title.text,photo.source,description.text,date.text);
                    stack.pop()
                }else{
                    console.log("Inform the user that there is an existing destination with the same (name,imgNAME) values. This entry he is trying to save is considered a duplicate. \n(Note: ///C:/aaa/bbb/brazil.jpg) is the same as ///C:/ccc/ddd/eee/brazil.jpg")
                }
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        folder: shortcuts.pictures
        //nameFilters: [ "Image files (*.jpg *.png)", "All files (*)" ]
        nameFilters: [ "Image files (*.jpg *.png)" ]
        onAccepted: {
            console.log("You chose: " + fileDialog.fileUrl)
            photo.height = 100
            photo.width = 200
            photo.source = fileDialog.fileUrl
        }
        onRejected: {
            console.log("Canceled")
        }
    }

}
