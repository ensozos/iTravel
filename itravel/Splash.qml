import QtQuick 2.0
import QtQuick.Window 2.1

//Works for Desktop
//Does not work for Android (see Manifest.xml splash properties)

//! [splash-properties]
Window {
    id: splash
    color: "transparent"
    title: "Splash Window"
    modality: Qt.ApplicationModal
    flags: Qt.SplashScreen
    property int timeoutInterval: 0//3000
    signal timeout
//! [splash-properties]
//! [screen-properties]
    x:0
    y:0
    width: 640
    height: 480

    Image {
        id: splashImage
        source: "images/images/logoTravel.png"
        width:parent.width
        height:parent.height
        fillMode: Image.Stretch
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        NumberAnimation on opacity {
                id: createAnimation
                from: 0
                to: 1
                duration: 3000
            }
        Component.onCompleted: createAnimation.start()
    }
    //! [timer]
    Timer {
        interval: timeoutInterval; running: true; repeat: false
        onTriggered: {
            visible = false
            splash.timeout()
        }
    }
    //! [timer]
    Component.onCompleted: visible = true
}
