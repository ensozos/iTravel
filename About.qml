import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4

Rectangle {

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

    Text{
        id:mainTitle
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top:myToolBar.bottom
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: parent.height * 0.075
        text:qsTr("How to use iTravel")
    }


}
