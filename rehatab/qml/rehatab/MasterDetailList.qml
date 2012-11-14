import QtQuick 1.1

Row {

    property Item dialogDelegate;
    property Component listDelegate;

    function saveItem() {
        dialogDelegate.saveItem();
    }

    function newItem(item) {

        item_listview.model.insert(0, item);
        dialogDelegate.newItem(item);
        item_listview.currentIndex = 0;
    }

    function loadItems(model) {
        item_listview.currentIndex = -1
        item_listview.model = model;
        if (item_listview.model.size() > 0) {
            item_listview.currentIndex = 0
        }
    }

    Component.onCompleted: {
        dialogDelegate.parent = item_dialogparent
        dialogDelegate.anchors.fill = parent
    }

    ListView {
        id:item_listview
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.horizontalCenter
        keyNavigationWraps: true
        focus:true

        highlight: Rectangle { color: "lightsteelblue"}
        delegate: listDelegate

        onCurrentIndexChanged: {
            if (model.size() > 0 && currentIndex >= 0) {
                console.log("current Contract changed to " + currentIndex)

                saveItem();
                dialogDelegate.loadItem(model.at(currentIndex))
                dialogDelegate.visible = true

            } else {
                dialogDelegate.visible = false
            }
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                parent.currentIndex = parent.indexAt(mouse.x, mouse.y)
            }
        }

    }

    Item {
        id:item_dialogparent
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.horizontalCenter
        visible: item_listview.currentIndex > -1

        Rectangle {
            anchors.fill: parent
            color: "white"
        }
    }
}
