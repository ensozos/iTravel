import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
Rectangle
{
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
            width:50
            Image{
                source:"images/images/planet-earth.png"
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
        delegate: Rectangle
        {
        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                stack.push({item:destination_view,properties:{name:name,img:image,desc:desc,date:date}});

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

            }

        }
    }
}

}
