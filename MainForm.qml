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
        anchors.margins: 1
        cellWidth:210
        cellHeight:210
        clip:true

        //When we interact with a GridView item and some other items are forced to relocate, this is the animation that they do for their "x,y" change.
        displaced: Transition {
            NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad; duration:500 }
        }

        model: DelegateModel{
            id: visualModel
            model: mediator.destinationModel
            delegate:
                MouseArea{
                    id: delegateRoot

                    property int visualIndex: DelegateModel.itemsIndex //The index as shown in the screen
                    property int vectorIndex: index  //The index inside the vector

                    width:myGridView.cellWidth; height:myGridView.cellHeight
                    drag.target: delegateRect

                    //This delegate is also a DropArea. When the "item" that is being dragged enters this delegate's space, then we reposition this item with the dragged inside the Grid.
                    DropArea {
                        anchors { fill: parent; margins: 15 }
                        onEntered: {visualModel.items.move(drag.source.visualIndex, delegateRoot.visualIndex); console.log("dragged:"+drag.source.vectorIndex)}
                    }

                    //What happens when you click on the delegate MouseArea (or pressAndHold)
                    onClicked:
                    {
                        stack.push({item:destination_view,properties:{indexInModel:index,name:name,img:image,desc:desc,date:date}});
                    }
                    onPressAndHold:
                    {
                        stack.push({item:deleteDest_view,properties:{name:name,img:image,desc:desc,date:date,indexOfDestInModel:index}});
                    }

                    Rectangle
                    {
                        id: delegateRect
                        color: "transparent"
                        width:myGridView.cellWidth*0.9 //The tile size in the Grid
                        height:width
                        anchors {
                            horizontalCenter: parent.horizontalCenter;
                            verticalCenter: parent.verticalCenter
                        }
                        //Make the delegate Draggable
                        Drag.active: delegateRoot.drag.active
                        Drag.source: delegateRoot
                        Drag.hotSpot.x: width/2
                        Drag.hotSpot.y: height/2

                        //Make the delegate move around the screen when "icon.Drag.active" (the dragging effect).
                        //When the event "icon.Drag.active" happens, then we set (for the target: "icon") "root" as the target's parent and we "un-anchor" the target's horiz/vertic centers.
                        states: [
                            State {
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
                                height:(parent.width-5)*0.8
                                width:height
                                fillMode: Image.PreserveAspectFit
                                source:image
                            }
                            Label{
                                anchors.horizontalCenter: parent.horizontalCenter
                                verticalAlignment: Text.AlignVCenter
                                text:name
                            }
                            Button{
                                id: deleteDelegateButton
                                visible: isDelegateDeleteButtonVisible()
                                text:"Delete"
                                anchors.horizontalCenter: parent.horizontalCenter
                                onClicked: {
                                    stack.push({item:deleteDest_view,properties:{name:name,img:image,desc:desc,date:date,indexOfDestInModel:index}});
                                }
                            }
                        }
                        //--------------------------------------------------------------
                    }
            }
        }
    }

    function getDateColor(date){

            var unix_time = (new Date).getTime()
            var current_time = parseInt(unix_time.toString().substring(0,10),10)
            var travel_date = parseInt(date.getTime().toString().substring(0,10),10)


            if (current_time > travel_date)
            {
                console.log("Red")
            } else if (current_time + 604800 >= travel_date ){ //one week
                console.log("Blue")
            } else {
                console.log("Green")
            }


            console.log(current_time+ " " + travel_date)


        }

    function isDelegateDeleteButtonVisible(){
        return deleteDelegateButtonsAreVisible;
    }
}
