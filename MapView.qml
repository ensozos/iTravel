import QtQuick 2.0
import QtPositioning 5.5
import QtLocation 5.6
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4

Rectangle{

    CustomToolBar{
        id:myToolBar

        ToolButton{
            id:backIcon
            anchors.right: parent.right
            anchors.rightMargin: 5
            width:parent.height
            height:width
            Image{
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                source:"images/images/back.png"
                width:parent.width * 0.7
                height:width
            }
            style: addDestIcon.style
            onClicked:
            {
                stack.pop();
            }
        }
    }

    Plugin{
        id: osmplugin
        name:"osm"
    }

    Map {
        plugin: osmplugin
        width: parent.width
        height: parent.height
        anchors.top: myToolBar.bottom
        id: map
        zoomLevel: (maximumZoomLevel - minimumZoomLevel)/2
        activeMapType: supportedMapTypes[5]

        center {
                  latitude: 40.639607
                  longitude: 22.944710
              }

        gesture.acceptedGestures: MapGestureArea.PanGesture | MapGestureArea.FlickGesture | MapGestureArea.PinchGesture
        gesture.flickDeceleration: 3000
        gesture.enabled: true


    }

}
