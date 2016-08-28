import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick 2.2
import QtQuick.Dialogs 1.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import "qrc:/styles/styles/" 1.0

Rectangle {

    property var photos : [];

    CustomToolBar{
        id:myToolBar

        ToolButton{
            id:backIcon
            anchors.right: parent.right
            anchors.rightMargin: 5
            width:parent.height
            height:width
            Image{
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                source:Style.icons.back
                width:parent.width * 0.7
                height:width
            }
            background: Rectangle {
                color: backIcon.pressed? Style.color.accentDark : Style.color.accent
                border.width: 1
                border.color: Style.color.accentDark
                radius: 18
            }
            onClicked:
            {
                stack.pop();
            }
        }
    }

    Label{
        id: duplicateMessage
        anchors.top: myToolBar.bottom
        font.family:Style.text.font
        font.pointSize: Style.text.size.normal
        text: "Duplicate detected."
        visible: duplicateAnimation.running
    }

    Rectangle{
        id: container
        width: (parent.width>1000) ? 900 : (parent.width * 0.9) //If the width is <1200 then set is as "90% of parent" else set it as "1080"
        anchors{
            top: duplicateMessage.bottom;
            horizontalCenter: parent.horizontalCenter
            bottom: bottomRow.top;
            leftMargin: 10;
            topMargin: 10
        }
        clip:true //Makes the scrollable content invisible beyond the "container" rectangle

        Flickable //The draggable area
        {
            anchors.fill:parent
            contentWidth: parent.width
            contentHeight: col.height + 50
            interactive:true
            boundsBehavior: Flickable.StopAtBounds

            Column
            {
                id:col
                width:parent.width
                spacing: 20
                Button
                {
                    id: uploadPhoto
                    width: 150
                    height:25
                    flat:true
                    text: "Upload Photo"
                    anchors.horizontalCenter: parent.horizontalCenter
                    background: Rectangle {
                        color: Style.color.accent
                        border.width: 1
                        border.color: Style.color.accentDark
                    }
                    font.family:Style.text.font
                    font.pointSize: Style.text.size.big
                    opacity:0.7
                    onClicked: {
                        fileDialog.open()
                    }
                }

                Image
                {
                    id:photo
                    anchors.horizontalCenter: parent.horizontalCenter
                    asynchronous: true
                    fillMode: Image.PreserveAspectCrop
                    height:200
                    width :parent.width * 0.8
                    source:""
                }

                Column{
                    id:nameTxf
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text{
                        id:text
                        anchors.horizontalCenter: parent.horizontalCenter
                        text:"My dreaming trip"
                        font.family:Style.text.font
                        font.pointSize: Style.text.size.normal
                        opacity:0.7
                    }
                    TextField{
                        id:title
                        placeholderText: "Destination name"
                        font.family:Style.text.font
                        font.pointSize: Style.text.size.normal
                    }
               }

                //Gray Line
                Rectangle{
                    anchors.horizontalCenter: parent.horizontalCenter
                    width:parent.width
                    height:1
                    opacity:0.7
                    color:"gray"
                }

                Column{
                    id:dateCol
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 10

                    Text{
                        anchors.horizontalCenter: parent.horizontalCenter
                        text:"Date:"
                        font.family:Style.text.font
                        font.pointSize: Style.text.size.normal
                        opacity:0.7
                    }
                    Calendar{
                        id: calendar
                        frameVisible: false
                        style : CalendarStyle{
                            dayDelegate:Rectangle{

                                color: styleData.selected ? Style.color.accentDark : (styleData.visibleMonth && styleData.valid ? Style.color.accent : Style.color.backgroundDark);

                                Label {
                                    text: styleData.date.getDate()
                                    //font.pointSize: Style.text.size.normal
                                    //font.family: Style.text.font
                                    anchors.centerIn: parent
                                    color: styleData.valid ? Style.color.textOnAccent : Style.color.textOnBackground
                                }
                            }

                            //The customization code for the "navigationBar" has been taken from here: https://blog.qt.io/blog/2014/06/06/qt-weekly-12-qt-quick-controls-calendar/
                            navigationBar: Rectangle {
                                color: Style.color.primaryDark
                                height: dateText.height * 2

                                ToolButton {
                                    id: previousMonth
                                    width: parent.height
                                    height: width
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    Text{
                                        anchors.centerIn: parent
                                        text:"<"
                                        color: Style.color.textOnPrimary
                                        font.pointSize: Style.text.size.big
                                    }
                                    onClicked: control.showPreviousMonth()
                                }
                                Label {
                                    id: dateText
                                    text: styleData.title
                                    font.pointSize: Style.text.size.big
                                    color : Style.color.textOnPrimary
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    fontSizeMode: Text.Fit
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: previousMonth.right
                                    anchors.leftMargin: 2
                                    anchors.right: nextMonth.left
                                    anchors.rightMargin: 2
                                }
                                ToolButton {
                                    id: nextMonth
                                    width: parent.height
                                    height: width
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.right: parent.right
                                    Text{
                                        anchors.centerIn: parent
                                        text:">"
                                        color: Style.color.textOnPrimary
                                        font.pointSize: Style.text.size.big
                                    }
                                    onClicked: control.showNextMonth()
                                }
                            }
                            dayOfWeekDelegate: Rectangle {
                                color: Qt.darker(Style.color.accentDark , 1.2)
                                height: dateText2.height * 2
                                width: dateText2.width
                                Label {
                                    id: dateText2
                                    text: Qt.locale().dayName(styleData.dayOfWeek, control.dayOfWeekFormat)
                                    font.pointSize: Style.text.size.normal
                                    font.family: Style.text.font
                                    color: Style.color.textOnAccent
                                    anchors.centerIn: parent
                                }
                            }
                        }
                    }
                }

                //Gray Line
                Rectangle{
                    anchors.horizontalCenter: parent.horizontalCenter
                    width:parent.width
                    height:1
                    opacity:0.7
                    color:"gray"
                }

                Column{
                    anchors.horizontalCenter: parent.horizontalCenter
                    Text{
                        anchors.horizontalCenter: parent.horizontalCenter
                        text:"Things i want to do there:"
                        font.family:Style.text.font
                        font.pointSize: Style.text.size.normal
                        opacity:0.7
                    }
                    TextArea{
                        id:description
                        width: container.width * 0.9
                        height: 150
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        font.family:Style.text.font
                        font.pointSize: Style.text.size.normal
                    }
                }

                //Gray Line
                Rectangle{
                    anchors.horizontalCenter: parent.horizontalCenter
                    width:parent.width
                    height:1
                    opacity:0.7
                    color:"gray"
                }

                Button{
                    anchors.horizontalCenter: parent.horizontalCenter
                    background: Rectangle {
                        color: Style.color.accent
                        border.width: 1
                        border.color: Style.color.accentDark
                    }
                    text: "Add photos to the photo album"
                    onClicked:{
                        photoAlbumDialog.open()
                    }
                    font.family:Style.text.font
                    font.pointSize: Style.text.size.big
                    opacity:0.7
                    flat: true
                }

                Component
                {
                    id: delegateEditable

                    Column{
                        spacing: 2
                        scale: PathView.iconScale
                        opacity: PathView.iconOpacity
                        rotation: PathView.itemRotation

                        MouseArea
                        {
                            id:photoAlbumImageArea
                            width:64
                            height:64
                            Image
                            {
                                width: parent.width
                                height: parent.height
                                source: icon
                                asynchronous: true
                                fillMode: Image.PreserveAspectCrop
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
                            anchors.horizontalCenter: photoAlbumImageArea.horizontalCenter
                            background: Rectangle {
                                color: Style.color.accent
                                border.width: 1
                                border.color: Style.color.accentDark
                            }
                            contentItem:Text{
                                text:"Remove It?"
                                font.family: Style.text.font
                                font.pointSize: Style.text.size.normal
                                color: Style.color.textOnAccent
                            }
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

                ListModel {
                    id: myPhotosModel
                }

                PathView
                {
                    id:viewEditable
                    width: parent.width
                    height: 250
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
        anchors.right: container.right
        anchors.bottomMargin: 10
        spacing: 10

        Text{
            text:"Done?"
            anchors.verticalCenter: parent.verticalCenter
            opacity: 0.2
            color:Style.color.textOnBackground
            font.family: Style.text.font
            font.pointSize: Style.text.size.small
        }

        Button{
            height: myToolBar.height - 5
            width: height

            contentItem:Image{
                anchors.centerIn: parent
                width: parent.width * 0.9
                height:width
                source:Style.icons.done
            }
            background: Rectangle {
                color: parent.pressed? Style.color.accentDark : Style.color.accent
                border.width: 1
                border.color: Style.color.accentDark
                radius: 20
            }
            onClicked: {

                console.log("\n----------------------------\nInsert New Destination:"+"\nImage:"+photo.source+"\nTitle:"+title.text+"\nDate:"+calendar.selectedDate+"\nDescription:"+description.text+"\n----------------------------")
                if(photo.source == ""){
                    photo.source = "images/images/noImage.png"
                }
                if(!mediator.isDuplicateDestination(title.text,photo.source, -1)){
                    mediator.insertDestination(title.text,photo.source,description.text,0,calendar.selectedDate,photos,"");
                    stack.pop()
                }else{
                    console.log("Inform the user that there is an existing destination with the same (name,imgNAME) values. This entry he is trying to save is considered a duplicate. \n(Note: ///C:/aaa/bbb/brazil.jpg) is the same as ///C:/ccc/ddd/eee/brazil.jpg")
                    duplicateAnimation.start()
                }
            }
        }
    }

    ParallelAnimation{
        id: duplicateAnimation
        running: false
        PropertyAnimation {id:duplicateColorAnimation; target: container; properties: "color"; from:"#ff4d4d"; to: container.color; duration: 1600}
        PropertyAnimation {target: duplicateMessage; properties: "opacity"; from:1; to: 0; duration: 2200}
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
