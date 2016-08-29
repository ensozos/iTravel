pragma Singleton
import QtQuick 2.0
QtObject {

    property QtObject color: QtObject{
        property color primary          : "#303F9F"
        property color primaryDark      : "#1A237E"
        property color accent           : "#F44336"
        property color accentDark       : "#B71C1C"
        property color background       : "white"
        property color backgroundDark   : "gray"
        property color textOnPrimary    : "white"
        property color textOnAccent     : "white"
        property color textOnBackground : "black"
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
        property string add         : "images/images/icons/white/add.png"
        property string settings    : "images/images/icons/white/settings.png"
        property string editOn      : "images/images/icons/white/editOn.png"
        property string editOff      : "images/images/icons/white/editOff.png"
        property string delete_     : "images/images/icons/white/delete.png"
        property string back        : "images/images/icons/white/back.png"
        property string save        : "images/images/icons/white/save.png"
        property string done        : "images/images/icons/white/done.png"
        property string time        : "images/images/icons/white/time.png"

    }
}
