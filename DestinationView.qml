import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3


Rectangle{

    property string name
    property string img
    property string desc
    property string date

    CustomToolBar{
        id:myToolBar
    }

    Label{

         width: parent.width
         height: parent.height
         text:name
    }

}
