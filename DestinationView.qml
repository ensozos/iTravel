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
    property string date

    property bool isEditingEnabled : false

    function makeElementsEditable(makeThemEditable){
        if(makeThemEditable){
            editableColumn.visible    = true
            nonEditableColumn.visible = false
        }else{
            //Set the new values to the nonEditable elements
            name = nameField.text
            date = dateField.text
            desc = descField.text
            //"img" has already been set in the "uploadButton" onClicked listener

            editableColumn.visible    = false
            nonEditableColumn.visible = true
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
                    mediator.editDestination(indexInModel,nameField.text,/*SET THIS img VALUE TO WHATEVER WE PICK FROM THE FILE CHOOSER*/img,descField.text,dateField.text)
                }else{
                    mediator.editDestination(indexInModel,name,img,desc,date)
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

    Column{
        id: nonEditableColumn
        anchors.top: myToolBar.bottom
        anchors.left: parent.left
        anchors.margins: 20
        spacing: 10

        Label{id:nameLabel; text:name}
        Label{id:dateLabel; text:date}
        Label{id:descLabel; text:desc}
        Image{
            source: img
            asynchronous: true
            width: 200
            height:100
            fillMode: Image.PreserveAspectFit
        }
    }

    Column{
        id: editableColumn
        visible: false
        anchors.top: myToolBar.bottom
        anchors.left: parent.left
        anchors.margins: 20
        spacing: 10

        TextField{id:nameField; text:name}
        TextField{id:dateField; text:date}
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
