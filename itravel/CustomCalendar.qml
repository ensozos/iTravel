import QtQuick 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 1.4
import "qrc:/styles/styles/" 1.0

CalendarStyle{

    dayDelegate:Rectangle{

        color: styleData.selected ? Style.color.accentDark : (styleData.visibleMonth && styleData.valid ? Style.color.accent : Qt.darker(Style.color.background,1.2));
        Label {
            text: styleData.date.getDate()
            //font.pointSize: Style.text.size.normal
            //font.family: Style.text.font
            anchors.centerIn: parent
            color: styleData.visibleMonth && styleData.valid ? Style.color.textOnAccent : Style.color.textOnBackground
        }
    }

    //The customization code for the "navigationBar" has been taken from here: https://blog.qt.io/blog/2014/06/06/qt-weekly-12-qt-quick-controls-calendar/
    navigationBar: Rectangle {

        color: Style.color.primaryDark
        height: dateText.height * 2
        ToolButton {
            id: previousMonth
            width: parent.height
            height: width
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            Text{
                anchors.centerIn: parent
                text:"<"
                color: Style.color.textOnPrimary
                font.pointSize: Style.text.size.big
            }
            onClicked: control.showPreviousMonth()
        }
        Label {
            id: dateText
            text: styleData.title
            font.pointSize: Style.text.size.big
            color : Style.color.textOnPrimary
            font.family: Style.text.font
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            fontSizeMode: Text.Fit
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: previousMonth.right
            anchors.leftMargin: 2
            anchors.right: nextMonth.left
            anchors.rightMargin: 2
        }
        ToolButton {
            id: nextMonth
            width: parent.height
            height: width
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            Text{
                anchors.centerIn: parent
                text:">"
                color: Style.color.textOnPrimary
                font.pointSize: Style.text.size.big
            }
            onClicked: control.showNextMonth()
        }
    }

    dayOfWeekDelegate: Rectangle {
        color: Qt.darker(Style.color.accentDark , 1.2)
        height: dateText2.height * 2
        width: dateText2.width
        Label {
            id: dateText2
            text: Qt.locale().dayName(styleData.dayOfWeek, control.dayOfWeekFormat)
            font.pointSize: Style.text.size.normal
            font.family: Style.text.font
            color: Style.color.textOnAccent
            anchors.centerIn: parent
        }
    }
}
