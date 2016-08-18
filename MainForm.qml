import QtQml 2.0
import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
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
        model:mediator.destinationModel
        cellWidth:210
        cellHeight:210
        clip:true
        delegate:
            Rectangle
            {
                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        stack.push({item:destination_view,properties:{indexInModel:index,name:name,img:image,desc:desc,date:date}});
                    }
                    onPressAndHold:
                    {
                        stack.push({item:deleteDest_view,properties:{name:name,img:image,desc:desc,date:date,indexOfDestInModel:index}});
                    }
                }
                width:myGridView.cellWidth-10
                height:width

                Column
                {
                    width:parent.width

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
                        id:l
                        verticalAlignment: Text.AlignVCenter
                        height:(parent.width-5)/5
                        text:name
                        Component.onCompleted: getDateColor(date)
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
