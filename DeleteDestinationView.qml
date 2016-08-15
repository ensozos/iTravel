import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4


Rectangle{

    //The values of a Destination
    property string name
    property string img
    property string desc
    property string date

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

    Column{
        anchors.top: myToolBar.bottom
        anchors.left: parent.left
        anchors.margins: 20
        spacing: 10

        Label{text:name}
        Label{text:date}
        Label{text:desc}
        Image{
            source: img
            width: 200
            height:100
            fillMode: Image.PreserveAspectFit
        }
        Button{
            text:"Delete"
            onClicked: {
                console.log("Delete Button Pressed")
                mediator.deleteDestination(name,img,desc,date)
                stack.pop()
            }
        }
    }
}
