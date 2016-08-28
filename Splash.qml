import QtQuick 2.0
import QtQuick.Window 2.1

//! [splash-properties]
Window {
    id: splash
    color: "transparent"
    title: "Splash Window"
    modality: Qt.ApplicationModal
    flags: Qt.SplashScreen
    property int timeoutInterval: 5000
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
        MouseArea {
            anchors.fill: parent
            onClicked: Qt.quit()
        }
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
