// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import QmlFeatures 1.0
import "navigation.js" as NavJS
Rectangle {
    id: root_item
    width: 1024
    height: 768
    color:main_style.defaultBg

    Component.onCompleted: {
        NavJS.currentView = new Array()
        stateMaschine.calendarMenuState.isActiveChanged.connect(NavJS.fnSwitchToCalendar)
        stateMaschine.groupMenuState.isActiveChanged.connect(NavJS.fnSwitchToGroupView)
        stateMaschine.personMenuState.isActiveChanged.connect(NavJS.fnSwitchToClientView)
        stateMaschine.statisticMenuState.isActiveChanged.connect(NavJS.fnSwitchToStatisticView)

    }


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
        clip: true
        id: main_content
        anchors.top: main_nav.bottom
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

    }

    //
    // -- main views
    //

    Component {
        id: comp_calendar
        CalendarView {
            anchors.fill: parent
        }
    }

    Component {
        id: comp_groupoverview
        GroupOverView {
            anchors.fill: parent
        }
    }

    Component {
        id: comp_clientoverview
        ClientAndGroupView {
            anchors.fill: parent
        }
    }

    Component {
        id: comp_statisticview
        StatisticView {

        }
    }

}
