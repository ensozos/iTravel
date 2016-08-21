import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick 2.2
import QtQuick.Dialogs 1.0
import QtQuick.Controls 2.0

//SUGGESTION: We could have a photo gallery for each destination. (Ex. When we click on "Rio" we see the image,title,date,description and a photo gallery)

Rectangle {

   color:"#F2F2F2"

   property var photos : [];

    CustomToolBar{
        id:myToolBar
    }

    Rectangle{
        id: container
        color:"#FFFFFF"

        width: (parent.width>1000) ? 900 : (parent.width * 0.9) //If the width is <1200 then set is as "90% of parent" else set it as "1080"
        anchors{
            top: myToolBar.bottom;
            left: parent.left;
            bottom: bottomRow.top;
            leftMargin: 8;
            rightMargin:8;
            topMargin:8
        }
        clip:true //Makes the scrollable content invisible beyond the "container" rectangle

        Flickable //The draggable area
        {
            anchors.fill:parent
            contentWidth: parent.width
            contentHeight: col.height
            interactive:true
            boundsBehavior: Flickable.StopAtBounds

            Column

                        {

                            id:col

                            width:parent.width

                            spacing: 32






                            Row{

                                anchors.horizontalCenter: parent.horizontalCenter
                                                    spacing: 8
                                                    Text{
                                                        anchors.verticalCenter: parent.verticalCenter
                                                        text:"My Next Destination:"
                                                        font.family: "Helvetica Neue"
                                                        font.pixelSize: 16
                                                        //font.weight: Font.DemiBold

                                }



                            }

                            Row{

                                anchors.horizontalCenter: parent.horizontalCenter
                                                    spacing: 8
                                                    TextField{
                                                                            anchors.verticalCenter: parent.verticalCenter
                                                                            id:title
                                                                            placeholderText: "ex.Berlin,France,Mt.Olympus etc."
                                                                            font.family: "Helvetica Neue"
                                                                            font.pixelSize: 16
                                }
                            }

                            Row{
                                id:divider
                                width:parent.width
                                anchors.horizontalCenter: parent.horizontalCenter
                                                    spacing: 8
                                                    Rectangle {
                                                            border.width: 1
                                                            height: 2
                                                            width: parent.width
                                                            anchors.margins: 20
                                                            border.color: "#2d2b19"
                                                            opacity:0.3
                                                        }


                            }


                            Column{

                                anchors.horizontalCenter: parent.horizontalCenter

                                spacing: 8



                                Text{

                                    anchors.horizontalCenter: parent.horizontalCenter

                                    text:"Date:"
                                    font.family: "Helvetica Neue"
                                    font.pixelSize: 16

                                }

                                Calendar{

                                    id: calendar

                                    frameVisible: false

                                    opacity:0.5

                                }

                            }

                            Row{
                                id:divider2
                                width:parent.width
                                anchors.horizontalCenter: parent.horizontalCenter
                                                    spacing: 8
                                                    Rectangle {
                                                            border.width: 1
                                                            height: 2
                                                            width: parent.width
                                                            anchors.margins: 20
                                                            border.color: "#2d2b19"
                                                            opacity:0.3
                                                        }


                            }



                            Column{

                                anchors.horizontalCenter: parent.horizontalCenter

                                Text{
                                    anchors.horizontalCenter: parent.horizontalCenter

                                    text:"My Trip Notes"
                                    font.family: "Helvetica Neue"
                                    font.pixelSize: 16

                                }

                                TextArea{

                                    id:description

                                    width: container.width * 0.9

                                    height: 200


                                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere

                                }

                            }

                            Row{
                                id:divider3
                                width:parent.width
                                anchors.horizontalCenter: parent.horizontalCenter
                                                    spacing: 8
                                                    Rectangle {
                                                            border.width: 1
                                                            height: 2
                                                            width: parent.width
                                                            anchors.margins: 20
                                                            border.color: "#2d2b19"
                                                            opacity:0.3
                                                        }


                            }



                            Button

                            {

                                id: uploadPhoto

                                width: 150

                                height:50
                                flat:true

                                ColorAnimation {
                                    from: "white"
                                    to: "Cyan"
                                    duration: 200
                                }

                                anchors.horizontalCenter: parent.horizontalCenter



                                Text

                                {

                                    text: "Upload Photo"

                                    font.family: "Helvetica Neue"
                                    font.pixelSize: 16

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

                                anchors.horizontalCenter: parent.horizontalCenter

                                asynchronous: true

                                //fillMode: Image.PreserveAspectFit

                                height:0

                                width :0

                                source:""

                            }


                            Row{
                                id:divider4
                                width:parent.width
                                anchors.horizontalCenter: parent.horizontalCenter
                                                    spacing: 8
                                                    Rectangle {
                                                            border.width: 1
                                                            height: 2
                                                            width: parent.width
                                                            anchors.margins: 20
                                                            border.color: "#2d2b19"
                                                            opacity:0.3
                                                        }


                            }



                            Component

                            {

                                id: delegateEditable



                                Column{

                                    spacing: 10

                                    scale: PathView.iconScale

                                    opacity: PathView.iconOpacity

                                    rotation: PathView.itemRotation



                                    MouseArea

                                    {

                                        width:photoAlbumItemEditable.width; height:photoAlbumItemEditable.height

                                        Image

                                        {

                                            id:photoAlbumItemEditable

                                            width: 64; height: 64

                                            source: icon

                                            asynchronous: true

                                        }

                                        onClicked: {

                                            console.log("Clicked:"+index);

                                            if(!deletePhoto.visible){

                                                deletePhoto.visible = true;

                                            }else{

                                                deletePhoto.visible = false;

                                            }

                                        }

                                    }



                                    Button{

                                        id: deletePhoto

                                        visible: false

                                        text:"Remove It?"

                                        anchors.horizontalCenter: parent.horizontalCenter

                                        onClicked:{

                                            console.log("Deleted:"+index);

                                            if(index > -1){

                                                //Attention: Because the "js array" and "qml ListModel" are implemented as a "stack" -> All elements have the same position in the js array AND the qml ListModel.

                                                //We take advantage of this feature and we delete elements at a specific "index" taken from the "myPhotoModel".

                                                photos.splice(index, 1)      //Delete the photo at "index" inside the myPhotosModel from the javascript array "photos".

                                                myPhotosModel.remove(index,1)//Delete the photo at "index" inside the myPhotosModel from the qml model "myPhotosModel".

                                            }

                                        }

                                    }

                                }

                            }



                            Button{

                                Text

                                {

                                    text: "Add Album Photos"

                                    font.family: "Helvetica Neue"
                                    font.pixelSize: 16

                                    anchors.verticalCenter: parent.verticalCenter

                                    anchors.horizontalCenter: parent.horizontalCenter

                                }

                                anchors.horizontalCenter: parent.horizontalCenter

                                flat:true

                                width:150
                                height:50

                                ColorAnimation {
                                    from: "white"
                                    to: "blue"
                                    duration: 200
                                }

                                onClicked:{

                                    photoAlbumDialog.open()

                                }

                            }


                            ListModel {

                                id: myPhotosModel

                            }



                            PathView

                            {

                                id:viewEditable

                                width: parent.width

                                height: 200

                                model: myPhotosModel

                                delegate: delegateEditable

                                path:Ellipse {

                                    width: viewEditable.width

                                    height: viewEditable.height

                                    }

                            }





                        }

                    }



                }



                Row{

                    id: bottomRow

                    height:30

                    anchors.bottom: parent.bottom

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



                            console.log("\n----------------------------\nInsert New Destination:"+"\nImage:"+photo.source+"\nTitle:"+title.text+"\nDate:"+calendar.selectedDate+"\nDescription:"+description.text+"\n----------------------------")

                            if(photo.source == ""){

                                photo.source = "images/images/noImage.png"

                            }

                            if(!mediator.isDuplicateDestination(title.text,photo.source)){

                                mediator.insertDestination(title.text,photo.source,description.text,0,calendar.selectedDate,photos);

                                stack.pop()

                            }else{

                                console.log("Inform the user that there is an existing destination with the same (name,imgNAME) values. This entry he is trying to save is considered a duplicate. \n(Note: ///C:/aaa/bbb/brazil.jpg) is the same as ///C:/ccc/ddd/eee/brazil.jpg")

                            }

                        }

                    }

                }



                //FileDialogs slow down the startup time due to this known qml bug: https://bugreports.qt.io/browse/QTBUG-46477

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



                FileDialog {

                    id: photoAlbumDialog

                    selectMultiple: true

                    title: "Choose some photos for the photo album"

                    folder: shortcuts.pictures

                    nameFilters: [ "Image files (*.jpg *.png)" ]

                    onAccepted: {



                        console.log("You chose: " + photoAlbumDialog.fileUrls)



                        //Push each selected element inside the "photos" list

                        for (var i = 0; i < photoAlbumDialog.fileUrls.length; ++i){

                            photos.push(Qt.resolvedUrl(photoAlbumDialog.fileUrls[i]))



                            //Put each selected element in the PathView also

                            myPhotosModel.append({"icon":photoAlbumDialog.fileUrls[i]})

                        }

                    }

                    onRejected: {

                        console.log("Canceled")

                    }

                }

            }
