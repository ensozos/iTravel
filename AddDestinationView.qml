import QtQuick 2.0
import QtQuick.Controls 1.4

Rectangle {

    //We should make this toolbar a separate file and just put it in every view (and add to it whatever specific button in each view).
    ToolBar
    {
        id:myToolBar
        height: 40
        width:parent.width
        anchors.right: parent.right

        Text{
            text: "iTravel"
            font.pixelSize: 20
            font.family: "Arial"
            anchors.left:parent.left
        }
    }

    Rectangle{
        id: container
        color:"light blue"
        anchors.top: myToolBar.bottom
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: 10
        anchors.topMargin: 10
        width: (parent.width>1000) ? 900 : (parent.width * 0.9) //If the width is <1200 then set is as "90% of parent" else set it as "1080"

        Button{
            id: uploadPhoto
            anchors.left: parent.left
            anchors.top: parent.top
            width: 200
            height:25

            Text{
                text: "Upload Photo"
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Row{
            id: destinationRow
            anchors.top: uploadPhoto.bottom
            anchors.topMargin: 10
            spacing: 10

            Text{
                anchors.verticalCenter: parent.verticalCenter
                text:"Title:"
            }

            TextField{
                id:title
                placeholderText: "Destination Name"

            }
        }

        Row{
            id: dateRow
            anchors.top: destinationRow.bottom
            anchors.topMargin: 10
            spacing: 10

            Text{
                anchors.verticalCenter: parent.verticalCenter
                text:"Date:"
            }

            TextField{
                id:date
                placeholderText: "Visit Date"

            }
        }

        Column{
            id: descriptionCol
            anchors.top: dateRow.bottom
            anchors.topMargin: 20

            Text{
                text:"Description:"
            }

            TextArea{
                id:description
                width: 400
                height: 200
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            }
        }
    }

    Row{
        id: bottomRow
        anchors.bottom: container.bottom
        anchors.left: container.left
        anchors.bottomMargin: 10
        spacing: 10

        Button{
            text:"cancel"
            onClicked: {
                console.log("Canceled")
            }
        }

        Button{
            text:"apply"
            onClicked: {
                console.log("\n----------------------------\nInsert New Destination:\n"+"Title:"+title.text+"\nDate:"+date.text+"\nDescription:"+description.text+"\n----------------------------")
                stack.pop()
            }
        }
    }


}
