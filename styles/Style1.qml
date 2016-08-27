pragma Singleton
import QtQuick 2.0
QtObject {

    property QtObject color: QtObject{
        property color primary          : "#303F9F"
        property color primaryDark      : "#1A237E"
        property color accent           : "#F44336"
        property color accentDark       : "#B71C1C"
        property color background       : "light gray"
        property color backgroundDark   : "gray"
        property color textOnPrimary    : "white"
        property color textOnAccent     : "white"
        property color textOnBackground : "black"
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
}
