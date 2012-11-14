// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: topToolbar

    width: 664
    height: 124
    color: myPalette.buttonBg
    border.width: 4
    border.color: myPalette.buttonBorder

    Row {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 20
        spacing: 10
        TopToolbarButton {
            id: btShowPersonView
            imageurl: "content/user.png"
            selected: true
            onIsSelected: {
                btShowGroupView.selected = false

            }
        }
        TopToolbarButton {
            id: btShowGroupView
            imageurl: "content/users.png"
            onIsSelected: {
                btShowPersonView.selected = false
            }
        }

    }

}
