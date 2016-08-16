import QtQuick 2.0
import QtPositioning 5.5
import QtLocation 5.6

Rectangle{

    CustomToolBar{
        id:myToolBar
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


        gesture.flickDeceleration: 3000
        gesture.enabled: true


    }

}
