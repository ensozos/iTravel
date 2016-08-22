import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.1

Rectangle
{    
    property bool deleteDelegateButtonsAreVisible : false

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

        Text{
            text: "iTravel"
            font.pixelSize: 20
            font.family: "Arial"
            anchors.left:parent.left
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
            Text{
                text: "+"
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                //font.pointSize: 15
            }
            style: ButtonStyle {
                    background: Rectangle {
                        border.width: control.activeFocus ? 2 : 1
                        border.color: "#888"
                        radius: 18
                        gradient: Gradient {
                            GradientStop { position: 0 ; color: control.pressed ? "#ccc" : "#eee" }
                            GradientStop { position: 1 ; color: control.pressed ? "#aaa" : "#ccc" }
                        }
                    }
                }
            onClicked:
            {
                stack.push(addDest_view);
            }
        }

        ToolButton{
            id:deleteDestIcon
            anchors.right: addDestIcon.left
            anchors.rightMargin: 5
            width:parent.height
            height:width
            Text{
                text: "x"
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                //font.pointSize: 15
            }
            style: ButtonStyle {
                    background: Rectangle {
                        border.width: control.activeFocus ? 2 : 1
                        border.color: "#888"
                        radius: 18
                        gradient: Gradient {
                            GradientStop { position: 0 ; color:{ if(control.pressed)   {"#ccc"}else{"#eee"}}}
                            GradientStop { position: 1 ; color:{ if(control.pressed || deleteDelegateButtonsAreVisible){"#aaa"}else{"#ccc"}}}
                        }
                    }
                }
            onClicked:
            {
                deleteDelegateButtonsAreVisible = !deleteDelegateButtonsAreVisible
            }
        }
    }

    GridView
    {
        id:myGridView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: myToolBar.bottom
        anchors.bottom: parent.bottom
        //anchors.margins: 1
        cellWidth:parent.width
        cellHeight:210
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

                    width:myGridView.cellWidth; height:myGridView.cellHeight

                    //This delegate is also a DropArea. When the "item" that is being dragged enters this delegate's space, then we reposition this item with the dragged inside the Grid.
                    DropArea {
                        anchors { fill: parent; margins: 15 }
                        onEntered: {visualModel.items.move(drag.source.visualIndex, delegateRoot.visualIndex); console.log("dragged:"+drag.source.vectorIndex)}
                    }

                    //What happens when you click on the delegate MouseArea (or pressAndHold)
                    onClicked:
                    {
                        stack.push({item:destination_view,properties:{indexInModel:index,name:name,img:image,desc:desc,score:score,date:date,photos:photoAlbum}});
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

                        width:myGridView.cellWidth//*0.9 //The tile size in the Grid
                        height:210
                        border.width:1
                        border.color: getDateColor(date)
                        radius: 10
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
                                height:210 //(parent.width-5)*0.8
                                width:parent.width
                                fillMode: Image.PreserveAspectCrop
                                source:image

                                Label
                                {
                                    anchors.left: parent.left
                                    anchors.bottom: parent.bottom
                                    anchors.margins:2
                                    verticalAlignment: Text.AlignVCenter
                                    text:name
                                    font.family:"Helvetica Neue"
                                    font.capitalization:Font.AllUppercase
                                    color: "#ffffff"
                                    font.weight: Font.Bold
                                    font.pointSize: 18
                                    Component.onCompleted: getDateColor(date)
                                }

                                Image
                                {
                                    id: editIcon
                                    visible: isDelegateDeleteButtonVisible()
                                    width:25
                                    height:25
                                    source:"images/images/editOn.png"
                                    anchors.bottom: parent.bottom
                                    anchors.right:deleteDelegateButton.left
                                    anchors.margins: 2


                                    MouseArea
                                    {
                                       anchors.fill: parent
                                       propagateComposedEvents: true
                                       onClicked: {}
                                    }
                                }

                                Image
                                {
                                     id: deleteDelegateButton
                                     visible: isDelegateDeleteButtonVisible()
                                     width:25
                                     height:25
                                     source:"images/images/marker.png"
                                     anchors.bottom: parent.bottom
                                     anchors.right:parent.right
                                     anchors.margins: 2


                                     MouseArea
                                     {
                                        anchors.fill: parent
                                        propagateComposedEvents: true
                                        onClicked: {
                                            stack.push({item:deleteDest_view,properties:{name:name,img:image,desc:desc,date:date,indexOfDestInModel:index}});
                                        }
                                    }
                                }

                                /*Button{

                                    //id: deleteDelegateButton
                                    visible: isDelegateDeleteButtonVisible()
                                    text:"Delete"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    onClicked: {
                                        stack.push({item:deleteDest_view,properties:{name:name,img:image,desc:desc,date:date,indexOfDestInModel:index}});
                                    }
                                }*/
                            }
                        //--------------------------------------------------------------
                        }
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

    function isDelegateDeleteButtonVisible(){
        return deleteDelegateButtonsAreVisible;
    }
}
