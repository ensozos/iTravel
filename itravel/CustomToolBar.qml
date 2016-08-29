import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "qrc:/styles/styles/" 1.0

ToolBar
{
    height: 40
    width:parent.width
    anchors.right: parent.right

    style:ToolBarStyle{
        background:Rectangle{
            color: Style.color.primary

            //gradient: Gradient {
            //    GradientStop { position: 0 ; color: Style.color.primary }
            //    GradientStop { position: 1 ; color: Style.color.primaryDark }
            //}
        }
    }

    Text{
        text: "iTravel"
        anchors.left:parent.left
        font.pointSize  : Style.text.size.huge
        font.family     : Style.text.font
        color           : Style.color.textOnPrimary
    }
}

