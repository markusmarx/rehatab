import QtQuick 1.1

Rectangle {
    border.color: "#cc0000"
    color: "transparent"
    border.width: 2

    Behavior on opacity {
        NumberAnimation {duration: 500}
    }
}
