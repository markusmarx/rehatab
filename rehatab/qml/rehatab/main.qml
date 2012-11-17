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


    Component {
        id: sexErrorRec
        Rectangle {
            border.color: "#FF7777"
            color: "#FF7777"
            border.width: 2
            x: -5
            z: -1

            Behavior on opacity {
                NumberAnimation { duration: 500}
            }
        }
    }

    Component {
        id: defaultErrorRec
        Rectangle {
            border.color: "#cc0000"
            color: "transparent"
            border.width: 2

            Behavior on opacity {
                NumberAnimation {duration: 500}
            }
        }
    }

    Component {
        id: defaultErrorMessage
        ToolTip {
            width: text.width+20
            height: text.height+15
            property alias message: text.text
            Text {
                id:text
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                color: "white"
            }

            Behavior on opacity {
                NumberAnimation { duration:500}
            }
        }
    }

    Component {
        id: topErrorMessage
        ToolTip {
            width: text.width+20
            height: text.height+15
            anchor: Qt.AlignTop
            property alias message: text.text
            Text {
                id:text
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                color: "white"
            }

            Behavior on opacity {
                NumberAnimation { duration:500}
            }
        }
    }

}
