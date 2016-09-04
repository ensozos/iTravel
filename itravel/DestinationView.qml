import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.0
import "qrc:/styles/styles/" 1.0

Rectangle{

    id:rootRectangle
    color : Style.color.background

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
    property bool events
    property bool souv

    property bool isEditingEnabled

    Component.onCompleted: {
        parseQuestions(questions.toString())
        fillListModelWithPhotos()
        makeElementsEditable(isEditingEnabled)
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
            events = (ans[4] === "true")
            souv = (ans[5] === "true")

        }else{

            museum = false
            number_of_photos = '0'
            traditional = false
            vacation = '0'
            events = false
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
            events = events_edit.checked
            souv = souvenir_edit.checked

            //"img" has already been set in the "uploadButton" onClicked listener

            editableColumn.visible    = false
            nonEditableColumn.visible = true
        }
    }


    function setScore(){

        var oldScore = score
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

        if (events_edit.checked) {
            score+= 15
            questions += "true" + "-"
            console.log("events part")
        }else {
            questions +="false" + "-"
            console.log("not event")
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
        mediator.updateTotalScore(oldScore,score)
    }

    CustomToolBar{
        id:myToolBar

        ProgressBar {
            anchors.centerIn: parent
            value:score/100
            style: ProgressBarStyle {
                background: Rectangle {
                    radius: 10
                    color       : Style.color.textOnPrimary
                    border.color: Style.color.primaryDark
                    border.width: 1
                    implicitWidth: 200
                    implicitHeight: 24
                }
                progress: Rectangle {
                    radius: 10
                    color       : Style.color.accent
                    border.color: Style.color.accentDark
                    Text {
                        id: progr_title                        
                        anchors.centerIn: parent
                        text: score.toString()
                        color: Style.color.textOnAccent
                        font.pointSize: Style.text.size.normal
                        font.family: Style.text.font
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
                source:Style.icons.save
                width:parent.width * 0.7
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
            clip:true
            Image{
                id:editImage
                anchors.verticalCenter: editDestIcon.verticalCenter
                anchors.horizontalCenter: editDestIcon.horizontalCenter
                source: isEditingEnabled? Style.icons.editOff : Style.icons.editOn
                width:parent.width * 0.75
                height:width
            }
            style: addDestIcon.style
            onClicked:
            {
                if(!isEditingEnabled){
                    console.log("Enable Editing")
                    isEditingEnabled = true
                    makeElementsEditable(true)
                }else{
                    console.log("Disable Editing")
                    isEditingEnabled = false
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
            Image{
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                source:Style.icons.back
                width:parent.width * 0.7
                height:width
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
        font.family: Style.text.font
        color: Style.color.textOnBackground
        font.pointSize: Style.text.size.normal
        visible: duplicateAnimation.running
        height: 0
    }

    Flickable{

        id:container
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
            width: parent.width
            spacing: 10

            Image{
                anchors.horizontalCenter: parent.horizontalCenter
                source: img
                asynchronous: true
                width: parent.width>500? 500 : parent.width
                height:300
                fillMode: Image.PreserveAspectCrop
            }
            Label{id:nameLabel
                 text:name
                 font.family: Style.text.font
                 font.pointSize: Style.text.size.big
                 color:Style.color.textOnBackground
                 anchors.horizontalCenter: parent.horizontalCenter
            }

            Label{id:descLabel
                text:desc
                font.family: Style.text.font
                font.pointSize: Style.text.size.normal
                color:Style.color.textOnBackground
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Calendar
            {
                id:dateLabel
                selectedDate: date
                enabled: false
                anchors.horizontalCenter: parent.horizontalCenter
                style : CustomCalendar{}
            }

            Component
            {
                id: delegate
                Rectangle
                {
                    id:delegateRectangle
                    width:64; height:64
                    scale: PathView.iconScale
                    opacity: PathView.iconOpacity
                    rotation: PathView.itemRotation

                    MouseArea{
                        id: delegateArea

                        states: [
                            State {
                                name: "big"
                                ParentChange {
                                    target: delegateArea
                                    parent: container
                                    x: container.x
                                    y: container.y
                                }
                                AnchorChanges {
                                    target: delegateArea
                                    anchors.right   : container.right
                                    anchors.left    : container.left
                                    anchors.top     : container.top
                                    anchors.bottom  : container.bottom
                                }
                            },
                            State {
                                name: "small"
                                ParentChange {
                                    target: delegateArea
                                    parent: delegateRectangle
                                }
                                AnchorChanges {
                                    target: delegateArea
                                    anchors.right   : delegateRectangle.right
                                    anchors.left    : delegateRectangle.left
                                    anchors.top     : delegateRectangle.top
                                    anchors.bottom  : delegateRectangle.bottom
                                }
                            }
                        ]

                        transitions: Transition {
                            ParallelAnimation{
                                AnchorAnimation { duration: 300; }
                                ParentAnimation { NumberAnimation { properties: "x,y"; duration: 300}}
                            }
                        }
                        Component.onCompleted: {delegateArea.state = "small"}

                        onClicked: {

                            if(delegateArea.state == "small"){
                                if(view.currentIndex == index){
                                    delegateArea.state = "big"
                                }
                            }else{
                                delegateArea.state = "small"
                            }
                        }

                        Image
                        {
                            id: photoAlbumItem
                            anchors.fill: parent
                            source: icon
                            asynchronous: true
                            fillMode: Image.PreserveAspectCrop
                        }
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
                        font.family: Style.text.font
                        font.pointSize: Style.text.size.normal
                        color:Style.color.textOnBackground
                    }

                    CheckBox {
                        id:museum_number
                        enabled: false
                        checked: museum
                        style:museum_number_edit.style
                    }
                }

                Row{
                    spacing: 10
                    Text {
                        text: qsTr("How many photos did you get?")
                        font.family:Style.text.font
                        font.pointSize: Style.text.size.normal
                        color:Style.color.textOnBackground
                    }

                    TextField{
                        id:photos_number
                        enabled: false
                        validator: IntValidator{bottom:0}
                        inputMethodHints: Qt.ImhDigitsOnly
                        text: number_of_photos
                        style: nameField.style
                    }
                }

                Row{
                    spacing: 10

                    Text {
                        text: qsTr("Did you ate any tradionotal food?")
                        font.family:Style.text.font
                        font.pointSize: Style.text.size.normal
                        color:Style.color.textOnBackground
                    }

                    CheckBox{
                        id:traditional_food
                        enabled: false
                        checked:traditional
                        style:museum_number_edit.style
                    }
                }

                Row{
                    spacing: 10

                    Text {
                        text: qsTr("Days of vacation?")
                        font.family:Style.text.font
                        font.pointSize: Style.text.size.normal
                        color:Style.color.textOnBackground
                    }

                    TextField{
                        id:vacation_days
                        validator: IntValidator{bottom:0}
                        enabled: false
                        inputMethodHints: Qt.ImhDigitsOnly
                        text: vacation
                        style: nameField.style
                    }
                }

                Row{
                    spacing: 10
                    Text {
                        text: qsTr("Did you participate in any event?")
                        font.family:Style.text.font
                        font.pointSize: Style.text.size.normal
                        color:Style.color.textOnBackground
                    }

                    CheckBox{
                        id:events_non_edit
                        enabled: false
                        checked: events
                        style:museum_number_edit.style
                    }
                }

                Row{
                    spacing: 10
                    Text {
                        text: qsTr("Did you buy any souvenir?")
                        font.family:Style.text.font
                        font.pointSize: Style.text.size.normal
                        color:Style.color.textOnBackground
                    }

                    CheckBox{
                        id:souvenir
                        enabled:false
                        checked: souv
                        style:museum_number_edit.style
                    }
                }
            }
        }
//EDIT ON-------------------------------------------------------------------------------------------------

        Column
        {
            id: editableColumn
            width: parent.width
            visible: false
            spacing: 10

            Item{
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width>500? 500 : parent.width
                height:300
                Image{
                    id: destinationImage
                    source: img
                    asynchronous: true
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectCrop
                    opacity: 0.2
                }
                MouseArea{
                    anchors.fill: destinationImage
                    Rectangle{
                        anchors.fill: parent
                        color: Style.color.primary
                        opacity: 0.6
                    }
                    Image{
                        anchors.top : parent.top
                        anchors.left : parent.left
                        width: 50
                        height : 50
                        source: "images/images/selectImage.gif"
                        fillMode: Image.PreserveAspectFit
                    }

                    onClicked: {

                        //Create a file dialog only when you need it (way better performance)
                        Qt.createQmlObject(
                                   'import QtQuick 2.0
                                    import QtQuick.Dialogs 1.0
                                    FileDialog {
                                        id: fileDialog
                                        title: "Please choose a file"
                                        folder: shortcuts.pictures
                                        nameFilters: [ "Image files (*.jpg *.png)" ]
                                        onAccepted: {
                                            console.log("You chose: " + this.fileUrl)
                                            rootRectangle.img = this.fileUrl
                                            this.destroy()
                                        }
                                        onRejected: {
                                            console.log("Canceled")
                                            this.destroy()
                                        }
                                        Component.onCompleted : {this.open()}
                                    }',
                                    rootRectangle,
                                    "errorReport"
                        )
                    }
                }
            }
            TextField{id:nameField
                text:name
                font.family: Style.text.font
                font.pointSize: Style.text.size.big
                anchors.horizontalCenter: parent.horizontalCenter
                validator: RegExpValidator { regExp: /[a-zA-Z,]{1,20}/ }
                style: TextFieldStyle {
                    textColor: Style.color.textOnBackground
                    background: Rectangle {
                        color:Style.color.backgroundDark
                    }
                }
            }
            TextArea{id:descField
                text:desc
                font.family: Style.text.font
                font.pointSize: Style.text.size.normal
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                style: TextAreaStyle {
                    frame: null
                    backgroundColor: Style.color.backgroundDark
                    textColor: Style.color.textOnBackground
                    selectionColor: Style.color.background
                    selectedTextColor: Style.color.textOnBackground
                }
            }

            Calendar
            {
                id:dateField
                selectedDate: date
                anchors.horizontalCenter: parent.horizontalCenter
                style : CustomCalendar{}
            }

            Component
            {
                id: delegateEditable

                Column
                {
                    spacing: 2
                    scale: PathView.iconScale
                    opacity: PathView.iconOpacity
                    rotation: PathView.itemRotation

                    MouseArea
                    {
                        id:photoAlbumItemEditable
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
                        anchors.horizontalCenter: photoAlbumItemEditable.horizontalCenter
                        visible: false
                        style: ButtonStyle {
                                background: Rectangle {
                                    implicitWidth: deletePhoto.width
                                    implicitHeight: deletePhoto.height
                                    color: Style.color.accent
                                    border.width: 1
                                    border.color: Style.color.accentDark
                                }
                                label: Text{
                                    text:"Remove It?"
                                    font.family: Style.text.font
                                    font.pointSize: Style.text.size.normal
                                    color: Style.color.textOnAccent
                                }
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
                anchors.horizontalCenter: parent.horizontalCenter

                style: ButtonStyle {
                    background: Rectangle {
                        color: Style.color.accent
                        border.width: 1
                        border.color: Style.color.accentDark
                    }
                    label: Text{
                        text: "Add photos to photo album"
                        font.family: Style.text.font
                        font.pointSize: Style.text.size.big
                        color: Style.color.textOnAccent
                    }
                }

                onClicked: {

                    //Create a file dialog only when you need it (way better performance)
                    Qt.createQmlObject(
                               'import QtQuick 2.0
                                import QtQuick.Dialogs 1.0
                                FileDialog {
                                    selectMultiple: true
                                    title: "Choose some photos for the photo album"
                                    folder: shortcuts.pictures
                                    nameFilters: [ "Image files (*.jpg *.png)" ]
                                    onAccepted: {

                                        console.log("You chose: " + this.fileUrls)

                                        //Push each selected element inside the "photos" list
                                        for (var i = 0; i < this.fileUrls.length; ++i){
                                            rootRectangle.photos.push(Qt.resolvedUrl(this.fileUrls[i]))

                                            //Put each selected element in the PathView also
                                            myPhotosModel.append({"icon":this.fileUrls[i]})
                                        }
                                        this.destroy()
                                    }
                                    onRejected: {
                                        console.log("Canceled")
                                        this.destroy()
                                    }
                                    Component.onCompleted: {this.open()}
                                }',
                                rootRectangle,
                                "errorReport"
                    )
                }
            }

            Column
            {
                anchors.horizontalCenter:parent.horizontalCenter
                spacing:15
                Row{
                    spacing: 10
                    Text {
                        text: qsTr("Did you visit a museum?")
                        font.family:Style.text.font
                        font.pointSize: Style.text.size.normal
                        color:Style.color.textOnBackground
                    }

                    CheckBox {
                        id:museum_number_edit
                        checked: museum
                        style: CheckBoxStyle {
                            indicator: Rectangle {
                                implicitWidth: 15
                                implicitHeight: 15
                                radius: 5
                                color:control.pressed? Style.color.accent : Style.color.backgroundDark
                                Image{
                                    anchors.fill:parent
                                    source:Style.icons.done
                                    visible: control.checked
                                }
                            }
                        }
                    }
                }

                Row{
                    spacing: 10
                    Text {
                        text: qsTr("How many photos did you get?")
                        font.family:Style.text.font
                        font.pointSize: Style.text.size.normal
                        color:Style.color.textOnBackground
                    }

                    TextField{
                        id:photos_number_edit
                        validator: IntValidator{bottom:0}
                        text: number_of_photos
                        inputMethodHints: Qt.ImhDigitsOnly
                        style: nameField.style
                    }
                }

                Row{
                    spacing: 10
                    Text {
                        text: qsTr("Did you ate any tradionotal food?")
                        font.family:Style.text.font
                        font.pointSize: Style.text.size.normal
                        color:Style.color.textOnBackground
                    }

                    CheckBox{
                        id:traditional_food_edit
                        checked:traditional
                        style:museum_number_edit.style
                    }
                }

                Row{
                    spacing: 10
                    Text {
                        text: qsTr("Days of vacation?")
                        font.family:Style.text.font
                        font.pointSize: Style.text.size.normal
                        color:Style.color.textOnBackground
                    }

                    TextField{
                        id:vacation_days_edit
                        validator: IntValidator{bottom:0}
                        text: vacation
                        inputMethodHints: Qt.ImhDigitsOnly
                        style: nameField.style
                    }
                }

                Row{
                    spacing: 10
                    Text {
                        text: qsTr("Did you participate in any event?")
                        font.family:Style.text.font
                        font.pointSize: Style.text.size.normal
                        color:Style.color.textOnBackground
                    }

                    CheckBox{
                        id:events_edit
                        checked: events
                        style:museum_number_edit.style
                    }
                }

                Row{
                    spacing: 10
                    Text {
                        text: qsTr("Did you buy any souvenir?")
                        font.family:Style.text.font
                        font.pointSize: Style.text.size.normal
                        color:Style.color.textOnBackground
                    }

                    CheckBox{
                        id:souvenir_edit
                        checked: souv
                        style:museum_number_edit.style
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
        PropertyAnimation {id:duplicateColorAnimation; target: rootRectangle ; properties: "color"; from:Style.color.accent; to: target.color; duration: 1600}
        PropertyAnimation {target: duplicateMessage; properties: "opacity"; from:1; to: 0; duration: 2200}
        PropertyAnimation {target: duplicateMessage; properties: "height"; from:30; to: 0; duration: 2300; easing.type: Easing.InBack}
    }
}
