import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
Rectangle
{

    ToolBar
    {
        id:myToolBar
        height: 40
        width:parent.width
        anchors.right: parent.right

        Text{
            text: "iTravel"
            font.pixelSize: 20
            font.family: "Arial"
            anchors.left:parent.left
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
