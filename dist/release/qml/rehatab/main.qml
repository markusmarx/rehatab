// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    width: 1024
    height: 768
    Rectangle {
        id: topRect
        color: myPalette.toolbar
        height: 160
        anchors {
            right: parent.right
            left: parent.left
        }

        Image {
            anchors.fill: parent
            source: "content/toolbarbg.png"
            fillMode: Image.Tile
        }

        TopToolbar {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 20
        }

    }
    Rectangle {
        color: myPalette.body
        anchors {
            right: parent.right
            left: parent.left
            top: topRect.bottom
            bottom: parent.bottom
        }

        PersonView {
            anchors.rightMargin: 20
            anchors.leftMargin: 20
            anchors.bottomMargin: 20
            anchors.topMargin: 20
            anchors.fill: parent

        }

    }

}
