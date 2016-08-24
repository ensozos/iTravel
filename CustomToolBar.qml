import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

ToolBar
{

    height: 40
    width:parent.width
    anchors.right: parent.right

    style:ToolBarStyle{
        background:Rectangle{
            color:"#0099cc"
            //opacity:0.5

            gradient: Gradient {
                            GradientStop { position: 0 ; color: "#FF4000" }
                            GradientStop { position: 1 ; color: "#FF8000" }
                        }

        }

    }


    Text{
        text: "iTravel"
        font.pixelSize: 18
        font.family: "Helvetica Neue"
        anchors.left:parent.left
    }

}

