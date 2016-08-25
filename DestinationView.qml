import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.0


Rectangle{

    //The values of a Destination
    property int indexInModel
    property string name
    property string img
    property string desc
    property date date
    property int score
    property var photos
    property string questions
    //for questions
    property string number_of_photos
    property bool museum
    property bool traditional
    property string vacation
    property bool first_here
    property bool souv

    property bool isEditingEnabled : false

    Component.onCompleted: {
        parseQuestions(questions.toString())
        fillListModelWithPhotos()
    }

    /**
        Photos that have been passed here from "MainForm.qml" are stored in a javascript array named "photos".
        This function adds each element of "photos" inside the qml ListModel "myPhotosModel" so that the PathView can show them.
        This function is only called once this page is loaded.
    */
    function fillListModelWithPhotos(){

        for (var i = 0; i < photos.length; ++i){
            myPhotosModel.append({"icon":photos[i]})
        }
    }

    function parseQuestions(q){

        if (Boolean(q)){
            var ans = questions.split('-')
            museum = (ans[0] === "true")
            number_of_photos = ans[1]
            traditional = (ans[2] === "true")
            vacation = ans[3]
            first_here = (ans[4] === "true")
            souv = (ans[5] === "true")

        }else{

            museum = false
            number_of_photos = '0'
            traditional = false
            vacation = '0'
            first_here = false
            souv = false

       }
    }

    function makeElementsEditable(makeThemEditable){
        if(makeThemEditable){
            editableColumn.visible    = true
            nonEditableColumn.visible = false
        }else{
            //Set the new values to the nonEditable elements
            name = nameField.text
            date = dateField.selectedDate
            desc = descField.text

            museum = museum_number_edit.checked
            number_of_photos = photos_number_edit.text
            traditional = traditional_food_edit.checked
            vacation = vacation_days_edit.text
            first_here = first_time_edit.checked
            souv = souvenir_edit.checked

            //"img" has already been set in the "uploadButton" onClicked listener

            editableColumn.visible    = false
            nonEditableColumn.visible = true
        }
    }


    function setScore(){
        score = 0
        if (museum_number_edit.checked) {
            score+=25
            questions = "true" + "-"
            console.log("museum!")
        }else{
            questions = "false" + "-"
        }

        if (photos_number_edit.text.length > 0){
            score+= parseInt(photos_number_edit.text)
            questions += photos_number_edit.text + "-"
            console.log("photos!")
        }else{
            questions += "0" + "-"
        }

        if (traditional_food_edit.checked) {
            score+=10
            questions += "true" + "-"
            console.log("tradion")
        }else{
            questions += "false" + "-"
        }

        if (vacation_days_edit.text.length > 0){
            score+= parseInt(vacation_days_edit.text)*2
            questions += vacation_days_edit.text + "-"
            console.log("vacation")
        }else{
            questions += "0" + "-"
        }

        if (first_time_edit.checked) {
            score+= 50
            questions += "true" + "-"
            console.log("first time here")
        }else {
            score+= 10
            questions +="false" + "-"
            console.log("not first time here")
        }
        if(souvenir_edit.checked){
            score+=5
            questions += "true"
            console.log("souvenir")
        }else{
            questions += "false"
        }
        console.log(questions)
        mediator.editDestinationQuestions(indexInModel,questions)
        mediator.editDestinationScore(indexInModel,score)
    }

    CustomToolBar{
        id:myToolBar


        ProgressBar {
            anchors.centerIn: parent
            value:score/100
            style: ProgressBarStyle {
                background: Rectangle {
                    radius: 10
                    color: "lightgray"
                    border.color: "gray"
                    border.width: 1
                    implicitWidth: 200
                    implicitHeight: 24
                }
                progress: Rectangle {
                    radius: 10
                    color: "lightsteelblue"
                    border.color: "steelblue"
                    Text {
                        id: progr_title
                        anchors.centerIn: parent
                        text: score.toString()
                    }
                }
            }
            Component.onCompleted: setScore()
        }

        ToolButton{
            id:saveDestIcon
            anchors.right: editDestIcon.left
            anchors.rightMargin: 5
            width:parent.height
            height:width
            Image{
                anchors.verticalCenter: saveDestIcon.verticalCenter
                anchors.horizontalCenter: saveDestIcon.horizontalCenter
                source:"images/images/save.png"
                width:parent.width * 0.6
                height:width
            }
            style: addDestIcon.style
            onClicked:
            {
                if(!mediator.isDuplicateDestination(nameField.text,img, indexInModel)){
                    console.log("Save Changes")
                    mediator.editDestination(indexInModel,nameField.text,/*SET THIS img VALUE TO WHATEVER WE PICK FROM THE FILE CHOOSER*/img,descField.text,dateField.selectedDate)
                    setScore()
                    mediator.setPhotoAlbum(indexInModel,photos);
                }else{
                    console.log("Inform the user that a destination with the same (name,imgName) exists, so this entry he is trying to save is a duplicate.")
                    duplicateAnimation.start()
                }
            }
        }

        ToolButton{
            id:editDestIcon
            anchors.right: backIcon.left
            anchors.rightMargin: 5
            width:parent.height
            height:width
            Image{
                id:editImage
                anchors.verticalCenter: editDestIcon.verticalCenter
                anchors.horizontalCenter: editDestIcon.horizontalCenter
                source:"images/images/editOn.png"
                width:parent.width * 0.75
                height:width
            }
            style: addDestIcon.style
            onClicked:
            {
                if(!isEditingEnabled){
                    console.log("Enable Editing")
                    isEditingEnabled = true
                    editImage.source = "images/images/editOff.png"
                    makeElementsEditable(true)
                }else{
                    console.log("Disable Editing")
                    isEditingEnabled = false
                    editImage.source = "images/images/editOn.png"
                    makeElementsEditable(false)
                }
            }
        }

        ToolButton{
            id:backIcon
            anchors.right: parent.right
            anchors.rightMargin: 5
            width:parent.height
            height:width
            Text{
                text: "<-"
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                //font.pointSize: 15
            }
            style: addDestIcon.style
            onClicked:
            {
                stack.pop();
            }
        }
    }

    Label{
        id: duplicateMessage
        anchors.top: myToolBar.bottom
        text: "Duplicate detected."
        font.family: "Helvetica Neue"
        font.pixelSize: 16
        height: 0
    }

    Flickable{

        anchors{
            top:duplicateMessage.bottom
            right:parent.right
            left:parent.left
            bottom:parent.bottom
        }
        contentWidth: parent.width
        contentHeight: nonEditableColumn.visible ? nonEditableColumn.height : editableColumn.height
        clip:true

//EDIT OFF-------------------------------------------------------------------------------------------------
        Column
        {
            id: nonEditableColumn
            width: parent.width //* 0.7
            spacing: 10

            Image{
                source: img
                asynchronous: true
                width: parent.width
                height:200
                fillMode: Image.PreserveAspectCrop
            }
            Label{id:nameLabel
                 text:name
                 font.family: "Helvetica Neue"
                 font.pixelSize: 32
                 anchors.horizontalCenter: parent.horizontalCenter
            }

            Label{id:descLabel
                text:desc
                font.family: "Helvetica Neue"
                font.pixelSize: 12

                anchors.horizontalCenter: parent.horizontalCenter

            }




            Calendar
            {
                id:dateLabel
                selectedDate: date
                enabled: false

                anchors.horizontalCenter: parent.horizontalCenter





            }



            Component
            {
                id: delegate
                Rectangle
                {
                    width:photoAlbumItem.width; height:photoAlbumItem.height
                    scale: PathView.iconScale
                    opacity: PathView.iconOpacity
                    rotation: PathView.itemRotation

                    Image
                    {
                        id: photoAlbumItem
                        width: 64; height: 64
                        source: icon
                        asynchronous: true
                    }
                }
            }

            PathView
            {
                id:view
                width: parent.width
                height: 200
                model: myPhotosModel
                delegate: delegate
                path:Ellipse {
                    width: view.width
                    height: view.height
                    }
            }





            Column{

                spacing: 15
                anchors.horizontalCenter:parent.horizontalCenter


                Row{
                    spacing: 10

                Text {
                    text: qsTr("Did you visit a museum?")

                    font.family:"Helvetica Neue"
                    font.pixelSize: 16
                }

                CheckBox {
                        id:museum_number
                        enabled: false
                        checked: museum
                }
                }






               Row{
                spacing: 10
                Text {
                    text: qsTr("How many photos did you get?")

                    font.family:"Helvetica Neue"
                    font.pixelSize: 16
                }

                TextField{
                   id:photos_number
                   enabled: false
                   validator: IntValidator{bottom:0}
                   inputMethodHints: Qt.ImhDigitsOnly
                   text: number_of_photos
                }

            }



            Row{
                spacing: 10

                Text {
                    text: qsTr("Did you ate any tradionotal food?")

                    font.family:"Helvetica Neue"
                    font.pixelSize: 16
                }

                CheckBox{
                    id:traditional_food
                    enabled: false
                    checked:traditional
                }

            }

            Row{
                spacing: 10
                Text {
                    text: qsTr("Days of vacation?")

                    font.family:"Helvetica Neue"
                    font.pixelSize: 16
                }

                TextField{
                    id:vacation_days
                    validator: IntValidator{bottom:0}
                    enabled: false
                    inputMethodHints: Qt.ImhDigitsOnly
                    text: vacation
                }

            }

            Row{
                spacing: 10
                Text {
                    text: qsTr("First time here?")

                    font.family:"Helvetica Neue"
                    font.pixelSize: 16
                }

                CheckBox{
                    id:first_time
                    enabled: false
                    checked: first_here
                }

            }

            Row{
                spacing: 10
                Text {
                    text: qsTr("Did you buy any souvenir?")

                    font.family:"Helvetica Neue"
                    font.pixelSize: 16
                }

                CheckBox{
                    id:souvenir
                    enabled:false
                    checked: souv
                }

            }
            }


        }
//EDIT ON-------------------------------------------------------------------------------------------------

        Column{
            id: editableColumn
            width: parent.width //* 0.7
            visible: false
            spacing: 10

            Image{
                source: img
                asynchronous: true
                width: parent.width
                height:200
                fillMode: Image.PreserveAspectCrop

            Button{
                id: uploadButton
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: Image.bottom
                text: "Upload another photo"
                onClicked: {
                    fileDialog.open()
                }
            }
            }
            TextField{id:nameField
                text:name
                font.family: "Helvetica Neue"
                font.pixelSize: 32
                anchors.horizontalCenter: parent.horizontalCenter
            }
            TextArea{id:descField
                text:desc
                font.pixelSize: 12
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere

            }

            Calendar
            {
                id:dateField
                selectedDate: date
                anchors.horizontalCenter: parent.horizontalCenter
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


            Button{
                text: "Add photos to photo album"
                onClicked: {
                    photoAlbumDialog.open();
                }
                anchors.horizontalCenter: parent.horizontalCenter
            }



            Column{
                anchors.horizontalCenter:parent.horizontalCenter
                spacing:15
                Row{
                    spacing: 10
                    Text {
                        text: qsTr("Did you visit a museum?")
                        font.family:"Helvetica Neue"
                        font.pixelSize: 16
                    }

                    CheckBox {
                        id:museum_number_edit
                        checked: museum
                    }
                }

                Row{
                    spacing: 10
                    Text {
                        text: qsTr("How many photos did you get?")
                        font.family:"Helvetica Neue"
                        font.pixelSize: 16
                    }

                    TextField{
                        id:photos_number_edit
                        validator: IntValidator{bottom:0}
                        text: number_of_photos
                        inputMethodHints: Qt.ImhDigitsOnly
                    }

                }


                Row{
                    spacing: 10
                    Text {
                        text: qsTr("Did you ate any tradionotal food?")
                        font.family:"Helvetica Neue"
                        font.pixelSize: 16
                    }

                    CheckBox{
                        id:traditional_food_edit
                        checked:traditional
                    }

                }

                Row{
                    spacing: 10
                    Text {
                        text: qsTr("Days of vacation?")
                        font.family:"Helvetica Neue"
                        font.pixelSize: 16
                    }

                    TextField{
                        id:vacation_days_edit
                        validator: IntValidator{bottom:0}
                        text: vacation
                        inputMethodHints: Qt.ImhDigitsOnly
                    }

                }

                Row{
                    spacing: 10
                    Text {
                        text: qsTr("First time here?")
                        font.family:"Helvetica Neue"
                        font.pixelSize: 16
                    }

                    CheckBox{
                        id:first_time_edit
                        checked: first_here
                    }

                }

                Row{
                    spacing: 10
                    Text {
                        text: qsTr("Did you buy any souvenir?")
                        font.family:"Helvetica Neue"
                        font.pixelSize: 16
                    }

                    CheckBox{
                        id:souvenir_edit
                        checked: souv
                    }

                }

            }

        }
    }
//-------------------------------------------------------------------------------------------------


    ListModel {
        id: myPhotosModel
    }

    ParallelAnimation{
        id: duplicateAnimation
        running: false
        PropertyAnimation {id:duplicateColorAnimation; target: rootRectangle ; properties: "color"; from:"#ff4d4d"; to: target.color; duration: 1600}
        PropertyAnimation {target: duplicateMessage; properties: "opacity"; from:1; to: 0; duration: 2200}
        PropertyAnimation {target: duplicateMessage; properties: "height"; from:30; to: 0; duration: 2300; easing.type: Easing.InBack}
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        folder: shortcuts.pictures
        //nameFilters: [ "Image files (*.jpg *.png)", "All files (*)" ]
        nameFilters: [ "Image files (*.jpg *.png)" ]
        onAccepted: {
            console.log("You chose: " + fileDialog.fileUrl)
            img = fileDialog.fileUrl
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
