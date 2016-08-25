import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4

Rectangle{

    //The values of a Destination
    property string name
    property string img
    property string desc
    property date date
    property int indexOfDestInModel //The position of this Destination inside the vector of thie "destinationModel"

    CustomToolBar{
        id:myToolBar

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
        id:flick
        anchors{
            top: myToolBar.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        contentHeight: deleteData.height
        contentWidth: width
        interactive:true
        //boundsBehavior: Flickable.StopAtBounds
        clip:true
    Column{

        id: deleteData
        width: parent.width
        spacing: 10

        Label{
            text:name;
            font.pixelSize: 32
            anchors.horizontalCenter: parent.horizontalCenter}
        Label{
            text:Qt.formatDate(date,"ddd dd MMM yyyy");
            font.pixelSize: 16
            anchors.horizontalCenter: parent.horizontalCenter}
        Label{
            text:desc;
            font.pixelSize: 16
            anchors.horizontalCenter: parent.horizontalCenter}
        Image{
            anchors.horizontalCenter: parent.horizontalCenter
            source: img
            asynchronous: true
            width: flick.width * 0.8
            height:flick.height * 0.7
            fillMode: Image.PreserveAspectCrop
        }
        Button{
            text:"Delete"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                console.log("Delete Button Pressed")
                mediator.deleteDestination(indexOfDestInModel)
                stack.pop()
            }
        }
    }}
}
