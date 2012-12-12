// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    id: topToolbar

    width: 664
    height: 40
//    color: myPalette.buttonBg
//    border.width: 4
//    border.color: myPalette.buttonBorder

    Row {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 40
        spacing: 10
        TopToolbarButton {
            id: btShowPersonView
            imageurl: "content/user.png"
            menuTxt: qsTr("Klienten")
            selected: stateMaschine.personMenuState.isActive
            onIsSelected: {
                stateMaschine.personMenu();
            }
        }
        TopToolbarButton {
            id: btShowGroupView
            imageurl: "content/users.png"
            selected: stateMaschine.calendarMenuState.isActive
            menuTxt: qsTr("Kalender")
            onIsSelected: {
                stateMaschine.calendarMenu();

            }
        }
    }
}
