import QtQuick 1.1
import QmlFeatures 1.0

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
