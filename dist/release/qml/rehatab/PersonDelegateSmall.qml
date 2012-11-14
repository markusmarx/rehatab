// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    width: 246
    height: 106
    property int modelId: personId
    Rectangle {
        anchors.fill:parent
        anchors.margins: 10
        color: myPalette.buttonBorder
        radius: 5
        border.color: myPalette.buttonBorder
        border.width: 5

    }


    Image {
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 5

        id:personImage
        source: "content/user.png"
    }

    Column {
        spacing: 2
        anchors {
            top: parent.top
            left: personImage.right
            leftMargin: 10
            right: parent.right
            bottom: parent.bottom
            topMargin: 20
        }
        Text {
            text:name + ",\n" + forename
            color: "white"
            font.family: "Arial"
            font.pointSize: 10
            font.bold: true
        }
        Text {
            text:"Alter: " + age + " (" + Qt.formatDate(birth, "dd.MM.yyyy") + ")"

            color: "white"
        }
        Text {
            text: "Rezept:" + recept
            color: "white"
        }
    }


}
