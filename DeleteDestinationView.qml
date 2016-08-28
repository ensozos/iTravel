import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import "qrc:/styles/styles/" 1.0

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

    Flickable
    {
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
        Column
        {
            id: deleteData
            width: parent.width
            spacing: 10

            Label
            {
                text:name;
                font.family:Style.text.font
                font.pointSize: Style.text.size.huge
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Label
            {
                text:Qt.formatDate(date,"ddd dd MMM yyyy");
                font.family:Style.text.font
                font.pointSize: Style.text.size.normal
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Label
            {
                text:desc;
                font.family:Style.text.font
                font.pointSize: Style.text.size.normal
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Image
            {
                anchors.horizontalCenter: parent.horizontalCenter
                source: img
                asynchronous: true
                width: flick.width>500? 500 : flick.width
                height:flick.height * 0.7
                fillMode: Image.PreserveAspectCrop
            }
            Button
            {
                id: deleteButton
                anchors.horizontalCenter: parent.horizontalCenter
                style: ButtonStyle {
                    background: Rectangle {
                        color: deleteButton.pressed? Style.color.accentDark : Style.color.accent
                        border.width: 1
                        border.color: Style.color.accentDark
                    }
                    label: Text{
                        text:"Delete"
                        font.family: Style.text.font
                        font.pointSize: Style.text.size.normal
                        color: Style.color.textOnAccent
                    }
                }
                onClicked: {
                    console.log("Delete Button Pressed")
                    mediator.deleteDestination(indexOfDestInModel)
                    stack.pop()
                }
            }
        }
    }
}
