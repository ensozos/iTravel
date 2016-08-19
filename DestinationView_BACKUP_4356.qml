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

    property bool isEditingEnabled : false

    function makeElementsEditable(makeThemEditable){
        if(makeThemEditable){
            editableColumn.visible    = true
            nonEditableColumn.visible = false
        }else{
            //Set the new values to the nonEditable elements
            name = nameField.text
            date = dateField.selectedDate
            desc = descField.text
            //"img" has already been set in the "uploadButton" onClicked listener

            editableColumn.visible    = false
            nonEditableColumn.visible = true
        }
    }

    function setScore(){
        if (first_generic.checked) {
            score = 10
        }
    }

    CustomToolBar{
        id:myToolBar

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
                console.log("Save Changes")
                if(isEditingEnabled){
                    mediator.editDestination(indexInModel,nameField.text,/*SET THIS img VALUE TO WHATEVER WE PICK FROM THE FILE CHOOSER*/img,descField.text,dateField.selectedDate)
                }else{
                    mediator.editDestinationScore(indexInModel,score)
                    mediator.editDestination(indexInModel,nameField.text,img,descField.text,dateField.selectedDate)
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

    Flickable{

        anchors{
            top:myToolBar.bottom
            right:parent.right
            left:parent.left
            bottom:parent.bottom
        }
        contentWidth: parent.width
        contentHeight: nonEditableColumn.visible ? nonEditableColumn.height : editableColumn.height
        clip:true

        Column{
            width: parent.width * 0.7
            id: nonEditableColumn
            spacing: 10

            Text {
                id: te
                text: score
            }

            Image{
                source: img
                asynchronous: true
                width: 200
                height:100
                fillMode: Image.PreserveAspectFit
            }
            Label{id:nameLabel; text:name}
            Calendar
            {
                id:dateLabel
                selectedDate: date
                enabled: false
            }
            Label{id:descLabel; text:desc}
<<<<<<< HEAD
            Image
            {
                source: img
                asynchronous: true
                width: 200
                height:100
                fillMode: Image.PreserveAspectFit
            }

            Component
            {
                id: delegate
                Column
                {
                    scale: PathView.iconScale
                    opacity: PathView.iconOpacity
                    rotation: PathView.itemRotation
                    id: wrapper
                    Image
                    {
                        anchors.horizontalCenter: nameText.horizontalCenter
                        width: 64; height: 64
                        source: icon
                    }
                    Text
                    {
                        id: nameText
                        text: name
                        font.pointSize: 16
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
=======

            Row{
                spacing: 5
                Text {
                    text: qsTr("Did you visit a museum?")
                }

                CheckBox {
                        id:first_generic
                        checked: false
                }

            }

            Button{
                text: "set score"
                onClicked: setScore()
            }

>>>>>>> 0d395f75fb189018deb9cee24c9522df4dbcca4b
        }

        Column{
            id: editableColumn
            visible: false
            spacing: 10

            TextField{id:nameField; text:name}
            Calendar
            {
                id:dateField
                selectedDate: date
            }

            TextArea{id:descField; text:desc}
            Image{
                source: img
                asynchronous: true
                width: 200
                height:100
                fillMode: Image.PreserveAspectFit
            }
            Button{
                id: uploadButton
                text: "Upload another photo"
                onClicked: {
                    fileDialog.open()
                }
            }
        }
    }

    ListModel {
        id: myPhotosModel
        ListElement {
            name: "Brazil"
            icon: "images/images/brazil.jpg"
        }
        ListElement {
            name: "New York"
            icon: "images/images/newyork.jpg"
        }
        ListElement {
            name: "Greece"
            icon: "images/images/greece.jpg"
        }
        ListElement {
            name: "No Image"
            icon: "images/images/noImage.png"
        }
        ListElement {
            name: "Save"
            icon: "images/images/save.png"
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
            img = fileDialog.fileUrl
        }
        onRejected: {
            console.log("Canceled")
        }
    }

}
