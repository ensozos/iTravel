import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4


Rectangle{

    //The values of a Destination
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
                console.log("Save")
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
            id:image
            source: img
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
            id:image2
            source: img
            width: 200
            height:100
            fillMode: Image.PreserveAspectFit
        }
        Button{
            id: uploadButton
            text: "Upload another photo"
            height: 15
            onClicked: {
                //1)File chooser
                //2)Set img = "what file chose"
            }
        }
    }

}
