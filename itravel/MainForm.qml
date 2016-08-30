import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.1
import "qrc:/styles/styles/" 1.0

Rectangle
{
    objectName: "mainForm"
    property bool delegateButtonsAreVisible : false
    property int totalScore

    color: Style.color.background

    Component
    {
        id:map_view
        MapView{}
    }

    Component
    {
        id:addDest_view
        AddDestinationView{}
    }

    Component
    {
        id:destination_view
        DestinationView{}
    }

    Component{
        id:deleteDest_view
        DeleteDestinationView{}
    }

    CustomToolBar{
        id:myToolBar

        ProgressBar {

            id:progressBarScore
            anchors.centerIn: parent
            value:totalScore/100
            width : parent.width * 0.3

            style: ProgressBarStyle {
                background: Rectangle {
                    radius: 10
                    color       : Style.color.textOnPrimary
                    border.color: Style.color.primaryDark
                    border.width: 1
                    implicitWidth: width
                    implicitHeight: 24
                }
                progress: Rectangle {
                    radius: 10
                    color       : Style.color.accent
                    border.color: Style.color.accentDark

                    //Cast the child to "Component"
                    Component{

                        //Load a component from another line of code
                        Loader{
                            anchors.centerIn: parent.parent
                            sourceComponent: progr_title
                        }
                    }
                }
            }

            //This is the component to be loaded on the progress bar
            Text {
                id: progr_title
                anchors.left:  parent.left //The parent is the ProgressBar
                anchors.leftMargin: parent.width*parent.value/2 - width/2
                anchors.verticalCenter: parent.verticalCenter
                text: totalScore
                color: Style.color.textOnAccent
            }
        }

        ToolButton{
            anchors.right: parent.right
            id:mapIcon
            width:parent.height
            height:width
            style: addDestIcon.style
            Image{
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                source:"images/images/planet-earth.png"
                width:parent.width
                height:width
            }
            onClicked:
            {
                stack.push(map_view);
            }
        }

        ToolButton{
            id:addDestIcon
            anchors.right: mapIcon.left
            anchors.rightMargin: 5
            width:parent.height
            height:width

            Image{
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                source:Style.icons.add
                width:parent.width * 0.7
                height:width
            }
            style: ButtonStyle {
                    background: Rectangle {
                        border.width: 1
                        border.color: Style.color.accentDark
                        radius: 18
                        gradient: Gradient {
                            GradientStop { position: 0 ; color: control.pressed ? Style.color.accent : Style.color.accentDark }
                            GradientStop { position: 1 ; color: control.pressed ? Style.color.accentDark : Style.color.accent }
                        }
                    }
                }
            onClicked:
            {
                stack.push(addDest_view);
            }
        }

        ToolButton{
            id:toggleOperationsIcon
            anchors.right: addDestIcon.left
            anchors.rightMargin: 5
            width:parent.height
            height:width
            Image{
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                source:Style.icons.settings
                width:parent.width * 0.6
                height:width
            }
            style: ButtonStyle {
                    background: Rectangle {
                        border.width: 1
                        border.color: Style.color.accentDark
                        radius: 18
                        gradient: Gradient {
                            GradientStop { position: 0 ; color:{ if(control.pressed)   {Style.color.accent}else{Style.color.accentDark}}}
                            GradientStop { position: 1 ; color:{ if(control.pressed || delegateButtonsAreVisible){Style.color.accentDark}else{Style.color.accent}}}
                        }
                    }
                }
            onClicked:
            {
                delegateButtonsAreVisible = !delegateButtonsAreVisible
            }
        }
    }

    GridView
    {
        id:myGridView
        width: {
            var w = parent.width
            if(w<500)               return w;
            else if(w>=500 & w<1000) return 500;
            else if(w>=1000)         return 1000;
        }
        cellWidth: parent.width>=1000? 500 : width
        cellHeight:250
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: myToolBar.bottom
        anchors.bottom: parent.bottom
        clip:true

        //When we interact with a GridView item and some other items are forced to relocate, this is the animation that they do for their "x,y" change.
        displaced: Transition {
            NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad; duration:500 }
        }

        model: DelegateModel
        {
            id: visualModel
            model: mediator.destinationModel
            delegate:
                MouseArea
                {
                    id: delegateRoot

                    property int visualIndex: DelegateModel.itemsIndex //The index as shown in the screen
                    property int vectorIndex: index  //The index inside the vector

                    width:myGridView.cellWidth;
                    height:myGridView.cellHeight

                    //This delegate is also a DropArea. When the "item" that is being dragged enters this delegate's space, then we reposition this item with the dragged inside the Grid.
                    DropArea {
                        anchors { fill: parent; margins: 15 }
                        onEntered: {visualModel.items.move(drag.source.visualIndex, delegateRoot.visualIndex); console.log("dragged:"+drag.source.vectorIndex)}
                    }

                    //What happens when you click on the delegate MouseArea (or pressAndHold)
                    onClicked:
                    {
                        stack.push({item:destination_view,properties:{indexInModel:index,name:name,img:image,desc:desc,score:score,date:date,photos:photoAlbum,questions:questions}});
                    }
                    onPressAndHold:
                    {
                        //Make the delegate draggable for repositioning
                        delegateRoot.drag.target = delegateRect
                        delegateRect.scale = 0.95
                        //stack.push({item:deleteDest_view,properties:{name:name,img:image,desc:desc,date:date,indexOfDestInModel:index}});
                    }
                    onReleased: {
                        //Make the delegate not draggable for repositioning (only for scrolling)
                        delegateRoot.drag.target = undefined
                        delegateRect.scale = 1
                    }

                    Rectangle
                    {
                        id: delegateRect
                        color: "transparent"

                        width:myGridView.cellWidth//The tile size in the Grid
                        height:myGridView.cellHeight
                        anchors {
                            horizontalCenter: parent.horizontalCenter;
                            verticalCenter: parent.verticalCenter
                        }

                        //Animate the "scale" changes
                        Behavior on scale { PropertyAnimation{duration: 100} }

                        //Make the delegate Draggable
                        Drag.active: delegateRoot.drag.active
                        Drag.source: delegateRoot
                        Drag.hotSpot.x: width/2
                        Drag.hotSpot.y: height/2

                        //Make the delegate move around the screen when "icon.Drag.active" (the dragging effect).
                        //When the event "icon.Drag.active" happens, then we set (for the target: "icon") "root" as the target's parent and we "un-anchor" the target's horiz/vertic centers.
                        states: [
                            State
                            {
                                when: delegateRect.Drag.active
                                ParentChange {
                                    target: delegateRect
                                    parent: myGridView
                                }

                                AnchorChanges {
                                    target: delegateRect;
                                    anchors.horizontalCenter: undefined;
                                    anchors.verticalCenter: undefined

                                }
                            }
                        ]

                        //The actual Data of the delegate -----------------------------
                        Column
                        {
                            anchors.fill: parent
                            Image
                            {
                                anchors.horizontalCenter: parent.horizontalCenter
                                id:img
                                asynchronous: true
                                height:parent.height
                                width:parent.width
                                fillMode: Image.PreserveAspectCrop
                                source:image

                                Row{
                                    anchors.bottom: parent.bottom
                                    anchors.left:parent.left
                                    anchors.margins: 2
                                    spacing: 5
                                    height: Style.text.size.huge * 1.34 //1point = 1.33pixels

                                    Item{
                                        height: parent.height
                                        width: height
                                        Image{
                                            id:timeIcon
                                            width: parent.width
                                            height: parent.height
                                            source : Style.icons.time
                                            z:1
                                        }
                                        Rectangle{
                                            anchors.centerIn: parent
                                            width: timeIcon.width - 4
                                            height: timeIcon.height - 4
                                            radius:15
                                            z:0
                                            //opacity: 0.6
                                            color: getDateColor(date)
                                            Component.onCompleted: getDateColor(date)
                                        }
                                    }

                                    Label
                                    {
                                        verticalAlignment: Text.AlignVCenter
                                        text:name
                                        font.family:Style.text.font
                                        font.capitalization:Font.AllUppercase
                                        color: Style.color.textOnImages
                                        font.weight: Font.Bold
                                        font.pointSize: Style.text.size.huge
                                    }
                                }

                                Rectangle{
                                    anchors.fill: iconsRow
                                    color: Style.color.accent
                                    opacity:0.3
                                }

                                Row{
                                    id: iconsRow
                                    anchors.bottom: parent.bottom
                                    anchors.right:parent.right
                                    anchors.margins: 2

                                    Image
                                    {
                                        id: editIcon
                                        visible: areDelegateButtonsVisible()
                                        width:25
                                        height:25
                                        source:Style.icons.editOn

                                        MouseArea
                                        {
                                           anchors.fill: parent
                                           propagateComposedEvents: true
                                           onClicked: {
                                               stack.push({item:destination_view,properties:{indexInModel:index,name:name,img:image,desc:desc,score:score,date:date,photos:photoAlbum,questions:questions,isEditingEnabled:true}});
                                           }
                                        }
                                    }

                                    Image
                                    {
                                         id: deleteDelegateButton
                                         visible: areDelegateButtonsVisible()
                                         width:25
                                         height:25
                                         source:Style.icons.delete_

                                         MouseArea
                                         {
                                            anchors.fill: parent
                                            propagateComposedEvents: true
                                            onClicked: {
                                                stack.push({item:deleteDest_view,properties:{name:name,img:image,desc:desc,date:date,score:score,indexOfDestInModel:index}});
                                            }
                                        }
                                    }
                                }
                            }
                        }//-------------------------------------------------------------------------
                    }
                }
        }


    }

    function getDateColor(date){

        var unix_time = (new Date).getTime()
        var current_time = parseInt(unix_time.toString().substring(0,10),10)
        var travel_date = parseInt(date.getTime().toString().substring(0,10),10)

        if (current_time > travel_date){
            return "red"
        } else if (current_time + 604800 >= travel_date ){ //one weak
            return "blue"
        } else {
            return "green"
        }
    }

    function areDelegateButtonsVisible(){
        return delegateButtonsAreVisible;
    }

    //Receive a "scoreSignal" from the target component with id:"controlWindow"
    Connections {
        target: controlWindow
        onScoreSignal: {
          handleScoreSignal()
        }
    }

    function handleScoreSignal(){
        console.log("Signal Cought!")
        //var randomScore = (Math.random() * 100)/100;
        //totalScore = randomScore
        //progressBarScore.value = randomScore
        //progr_title.text = Math.round(randomScore * 100)
        totalScore = mediator.getTotalScore()
        progressBarScore.value = totalScore/100
        progr_title.text = totalScore
    }
}
