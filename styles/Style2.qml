pragma Singleton
import QtQuick 2.0
QtObject {

    property QtObject color: QtObject{
        property color primary          : "#E91E63"
        property color primaryDark      : "#C2185B"
        property color accent           : "#FFF9C4"
        property color accentDark       : "#FFF176"
        property color background       : "light gray"
        property color backgroundDark   : "gray"
        property color textOnPrimary    : "white"
        property color textOnAccent     : "black"
        property color textOnBackground : "red"
        property color textOnImages     : "light gray"
    }

    property QtObject text: QtObject{

        property QtObject size: QtObject{
            property int small  : 10 //pointSize
            property int normal : 11
            property int big    : 15
            property int huge   : 18
        }
        property string font : "Helvetica Neue"
    }

    property QtObject icons : QtObject{
        property string add         : "images/images/icons/black/add.png"
        property string settings    : "images/images/icons/black/settings.png"
        property string editOn      : "images/images/icons/black/editOn.png"
        property string editOff      : "images/images/icons/black/editOff.png"
        property string delete_     : "images/images/icons/black/delete.png"
        property string back        : "images/images/icons/black/back.png"
        property string save        : "images/images/icons/black/save.png"
        property string done        : "images/images/icons/black/done.png"
        property string time        : "images/images/icons/black/time.png"

    }
}
