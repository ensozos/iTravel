pragma Singleton
import QtQuick 2.0
QtObject {

    property QtObject color: QtObject{
        property color primary     : "light green"
        property color primaryDark : "green"
        property color accent      : "light blue"
        property color accentDark  : "blue"
        property color background  : "light gray"
        property color toolBar     : "light gray"
        property color toolBarDark : "gray"
    }

    property QtObject text: QtObject{
        property QtObject size: QtObject{
            property int small : 10
            property int normal: 12
            property int big   : 16
            property int huge  : 32
        }
        property QtObject color: QtObject{
            property color toolBarText   : "white"
            property color primaryText   : "black"
            property color secondaryText : "gray"
        }
        property string font : "Helvetica Neue"
    }
}
