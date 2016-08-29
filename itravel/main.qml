import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4

Window {
    id:controlWindow
    visible: true
    width: 640
    height: 480
    Component
    {
        id:zero;
        MainForm {}
    }

    StackView
    {
        anchors.fill: parent
        initialItem: zero
        id: stack

    }

    property var splashWindow: Splash {
        onTimeout: controlWindow.visible = true
    }
}
