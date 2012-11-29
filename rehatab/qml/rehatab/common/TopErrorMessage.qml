import QtQuick 1.1
import QmlFeatures 1.0

ToolTip {
    width: text.width+20
    height: text.height+15
    anchor: Qt.AlignTop
    property alias message: text.text
    property Item relatedItem
    Component.onCompleted: {
        var pos = relatedItem.mapToItem(null, relatedItem.x, relatedItem.y)
        x = pos.x
        y = pos.y-relatedItem.height/2 - height
    }
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
