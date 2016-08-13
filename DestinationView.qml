import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4


Rectangle{

    property string name
    property string img
    property string desc
    property string date

    CustomToolBar{
        id:myToolBar

        ToolButton{
            id:addDestIcon
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
    }

}
