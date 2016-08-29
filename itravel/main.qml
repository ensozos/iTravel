import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4

Window {

    id:controlWindow
    visible: true
    width: 640
    height: 480

    //This component can emit a signal to other components
    signal scoreSignal();

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

        on__CurrentItemChanged: {
            if(currentItem != null){
                if(currentItem.objectName === "mainForm"){
                    scoreSignal() //Emit a signal
                }
            }
        }
    }

    property var splashWindow: Splash {
        onTimeout: controlWindow.visible = true
    }
}
