import QtQuick 2.0

// Ellipse (The following code has been taken from: https://wiki.qt.io/Qt_Quick_Carousel_Tutorial and it has been slightly modified)
Path {
    id: p
    property real width: 200
    property real height: 200
    property real margin: 50
    property real cx: width / 2
    property real cy: height / 2
    property real rx: width / 2 - margin
    property real ry: height / 2 - margin
    property real mx: rx * magic
    property real my: ry * magic
    property real magic: 0.551784
    startX: p.cx; startY: p.cy + p.ry


    PathAttribute { name: "iconScale"; value: 1.0 }
    PathAttribute { name: "iconOpacity"; value: 1.0 }
    PathAttribute { name: "itemRotation"; value: 0 }
    PathCubic // second quadrant arc
    {
        control1X: p.cx - p.mx; control1Y: p.cy + p.ry
        control2X: p.cx - p.rx; control2Y: p.cy + p.my
        x: p.cx - p.rx; y: p.cy
    }

    PathAttribute { name: "iconScale"; value: 0.75 }
    PathAttribute { name: "iconOpacity"; value: 0.75 }
    PathAttribute { name: "itemRotation"; value: 25 }
    PathCubic // third quadrant arc
    {
        control1X: p.cx - p.rx; control1Y: p.cy - p.my
        control2X: p.cx - p.mx; control2Y: p.cy - p.ry
        x: p.cx; y: p.cy - p.ry
    }

    PathAttribute { name: "iconScale"; value: 0.5 }
    PathAttribute { name: "iconOpacity"; value: 0.5 }
    PathAttribute { name: "itemRotation"; value: 50 }
    PathCubic // forth quadrant arc
    {
        control1X: p.cx + p.mx; control1Y: p.cy - p.ry
        control2X: p.cx + p.rx; control2Y: p.cy - p.my
        x: p.cx + p.rx; y: p.cy
    }

    PathAttribute { name: "iconScale"; value: 0.25 }
    PathAttribute { name: "iconOpacity"; value: 0.25 }
    PathAttribute { name: "itemRotation"; value: 75 }
    PathCubic // first quadrant arc
    {
        control1X: p.cx + p.rx; control1Y: p.cy + p.my
        control2X: p.cx + p.mx; control2Y: p.cy + p.ry
        x: p.cx; y: p.cy + p.ry
    }
}
