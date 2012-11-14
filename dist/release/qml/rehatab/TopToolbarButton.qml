// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: topToolbarButton
    width: 104
    height: 84

    property bool selected: false
    property string imageurl: ""
    signal isSelected
    color: myPalette.buttonBorder
    border.color: myPalette.buttonBorder
    border.width: 4

    Image {
        id: image
        source: imageurl
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        opacity: 0.5

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
        onClicked: {
            selected = true
            isSelected()
        }

    }

    states: [
        State {
            name: "selected"
            when: selected
            PropertyChanges {
                target: image
                opacity: 1
            }
            PropertyChanges {
                target: topToolbarButton
                border.color: "white"
                border.width: 4

            }
        },
        State {
            name: "unselected"
            PropertyChanges {
                target: topToolbarButton
                border.color: "#2886a8"
                border.width: 4

            }
        },
        State {
            name: "hovered"
            PropertyChanges {
                target: image
                opacity: 1
            }
        }

    ]

}
