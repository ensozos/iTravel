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
        score = 0
        if (museum_number.checked) {
            score+=25
            console.log("museum!")
        }
        if (photos_number.text.length > 0){
            score+= parseInt(photos_number.text)
            console.log("photos!")
        }
        if (traditional_food.checked) {
            score+=10
            console.log("tradion")
        }
        if (vacation_days.text.length > 0){
            score+= parseInt(vacation_days.text)*2
            console.log("vacation")
        }
        if (first_time.checked) {
            score+= 50
            console.log("first time here")
        }else {
            score+=10
            console.log("not first time here")
        }
        if(souvenir.checked){
            score+=5
            console.log("souvenir")
        }
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
                console.log("Save Changes")
                if(isEditingEnabled){
                    mediator.editDestination(indexInModel,nameField.text,/*SET THIS img VALUE TO WHATEVER WE PICK FROM THE FILE CHOOSER*/img,descField.text,dateField.selectedDate)
                }else{
                    setScore()
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

            Row{
                spacing: 5
                Text {
                    text: qsTr("Did you visit a museum?")
                }

                CheckBox {
                        id:museum_number
                        checked: false
                }

            }

            Row{
                spacing: 5
                Text {
                    text: qsTr("How many photos did you get?")
                }

                TextField{
                   id:photos_number
                   validator: IntValidator{}
                   placeholderText: qsTr("Enter number")
                   inputMethodHints: Qt.ImhDigitsOnly
                }

            }


            Row{
                spacing: 5
                Text {
                    text: qsTr("Did you ate any tradionotal food?")
                }

                CheckBox{
                    id:traditional_food
                    checked:false
                }

            }

            Row{
                spacing: 5
                Text {
                    text: qsTr("Days of vacation?")
                }

                TextField{
                    id:vacation_days
                    validator: IntValidator{}
                    placeholderText: qsTr("Number of days")
                    inputMethodHints: Qt.ImhDigitsOnly
                }

            }

            Row{
                spacing: 5
                Text {
                    text: qsTr("First time here?")
                }

                CheckBox{
                    id:first_time
                    checked: false
                }

            }

            Row{
                spacing: 5
                Text {
                    text: qsTr("Did you buy any souvenir?")
                }

                CheckBox{
                    id:souvenir
                    checked: false
                }

            }

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
