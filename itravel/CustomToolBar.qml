import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "qrc:/styles/styles/" 1.0

ToolBar
{
    height: appTitle.height * 1.5
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
        id:appTitle
        text: "iTravel"
        anchors.left:parent.left
        anchors.verticalCenter: parent.verticalCenter
        font.pointSize  : Style.text.size.huge
        font.family     : Style.text.font
        color           : Style.color.textOnPrimary
    }
}

