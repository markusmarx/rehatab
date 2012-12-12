// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import QtDesktop 0.1
Item {
    id: topToolbarButton
    width: text.width + 30
    height: 42

    property bool selected: false
    property string imageurl: ""
    property string menuTxt: "MenuText"
    signal isSelected

    Rectangle {
        anchors.fill: parent
        color: selected? main_style.navigationSelBg: "transparent"
        opacity: 0.7
    }

    Text {
        id: text
        color: "white"
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        text: menuTxt
    }


    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            if (!selected) {
                topToolbarButton.state = "hovered"
            }
        }
        onExited: {
            if (!selected) {
                topToolbarButton.state = "unselected"
            }
        }

        onClicked: isSelected()
    }
    CursorArea {
        anchors.fill: parent
        cursor: Qt.PointingHandCursor
    }


}
