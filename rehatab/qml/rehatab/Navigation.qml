import QtQuick 1.1

Item {
    z:0
    Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        color: main_style.navigationBg
    }

    Row {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 50
        anchors.right: parent.right
        spacing: 10
        anchors.bottom: parent.bottom
        property bool selectedItem
        TopToolbarButton {
            menuTxt: qsTr("Klienten")
            selected: stateMaschine.personMenuState.isActive
            onIsSelected: {
                stateMaschine.personMenu();
            }
        }
        TopToolbarButton {
            menuTxt: qsTr("Gruppen")
            selected: stateMaschine.groupMenuState.isActive
            onIsSelected: {
                stateMaschine.groupMenu();
            }
        }
        TopToolbarButton {
            selected: stateMaschine.calendarMenuState.isActive
            menuTxt: qsTr("Kalender")
            onIsSelected: {
                stateMaschine.calendarMenu();
            }
        }
    }

}
