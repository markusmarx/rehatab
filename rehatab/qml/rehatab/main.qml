// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import QmlFeatures 1.0

Rectangle {
    width: 1024
    height: 768
    color:main_style.defaultBg
    Style {
        id: main_style
    }

    Navigation {
        id:main_nav
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 42
    }


    Item {
        anchors.top: main_nav.bottom
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        ClientAndGroupView {
             anchors.fill: parent
             visible: stateMaschine.personMenuState.isActive || stateMaschine.groupMenuState.isActive
        }

        CalendarView {
            anchors.fill: parent
            visible: stateMaschine.calendarMenuState.isActive
        }


    }


}
