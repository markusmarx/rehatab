import QtQuick 1.1
import QtDesktop 0.1
import QmlFeatures 1.0

Item {
    property Item _visibleCurrentItem;
    property int selectedClientId;
    z: -1

    function fnClearSelection() {
        lst_view.currentIndex = -1
    }

    function fnSwitchToGroupView(open) {
        if (open) {
            //highlighter.opacity = 0
            //fnClearSelection()
        } else {
//            if (_lastSelectedClientId > 0) {
//                highlighter.opacity = 1
//                lst_view.currentIndex = _lastSelectedClientId-1
//            }
        }
    }

    Component.onCompleted: {
        stateMaschine.groupMenuState.isActiveChanged.connect(fnSwitchToGroupView);
    }

    ListView {
        id:lst_view
        anchors.fill: parent
        snapMode: ListView.SnapToItem
        model: clientController.personList()
        highlightMoveDuration:500
        currentIndex: -1

        Component.onCompleted: {
            currentIndex = -1
        }

        onCurrentIndexChanged: {

            if (currentIndex < 0) {
                highlighter.opacity = 0
                return;
            } else if (highlighter.opacity == 0) {
                behavior.enabled = false;
                highlighter.opacity = 1
            } else {
                behavior.enabled = true
            }
            if (_visibleCurrentItem) {
                _visibleCurrentItem.opacity = 0
                _visibleCurrentItem.destroy(300)
                //highlighter.color = "transparent"
            }

            //highlighter.x = currentItem.x
            if (currentItem.y-contentY < 0 || currentItem.y + currentItem.height - contentY > lst_view.height) {
                if (currentItem.y-contentY < 0) {
                    highlighter.y = 0
                } else {
                    highlighter.y = lst_view.height-highlighter.height
                }
            } else {
                highlighter.y = currentItem.y - contentY
            }

        }

        delegate:
            Item {
            width: parent.width-5
            height: 84
            signal openPerson(int personId)

            Component.onCompleted: {
                person_delegate.name = name
                person_delegate.forename = forename
                person_delegate.birth = birth
                person_delegate.age = age
            }

            MouseArea {
                id:mouseArea
                anchors.fill: parent
                hoverEnabled: true
                enabled: true

                onReleased: {
                    //if (stateMaschine.personMenuState.isActive) {
                        _lastSelectedClientId = id
                        lst_view.currentIndex = index
                        stateMaschine.openPerson();
                    //}
                }
            }

            Rectangle {
                anchors.fill: parent
                opacity: lst_view.currentIndex == index || mouseArea.containsMouse ?1:0
                color: "#ECECEC"
                Behavior on opacity {
                    NumberAnimation {
                        duration: 300
                    }
                }
            }


            PersonDelegateSmall {
                id: person_delegate
                property int oldY
                property Item oldParent


            }


            Rectangle {
                id: group_mover
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                width: 50
                height: 50
                visible: stateMaschine.groupMenuState.isActive
                color: "grey"
                opacity: 0.75

                DragArea {
                    anchors.fill: parent
                    delegate: comp_persondragdelegate
                    supportedActions: Qt.LinkAction
                    autoStart: true
                    data {
                        text: id
                        source: parent
                    }
                    onDrop: {
                        console.log("Drag Area: target accepted the drop with action : " + action)
                        group_mover.opacity = 0.75
                    }

                    onDragStarted: {
                        group_mover.opacity = 0
                    }
                }
            }

        }


        onContentYChanged: {
            behavior.enabled = false

            verticalScrollBar.blockupdates = true
            verticalScrollBar.value = contentY
            verticalScrollBar.blockupdates = false

            if (!currentItem) {
                return
            }

            if ((currentItem.y-contentY < 0 || currentItem.y + currentItem.height - contentY > lst_view.height) && !_visibleCurrentItem) {

                _visibleCurrentItem = comp_persondelegatesmall.createObject(parent)

                //highlighter.z = 1

                if (currentItem.y-contentY < 0) {
                    _visibleCurrentItem.y = 0
                } else {
                    _visibleCurrentItem.y = lst_view.height-currentItem.height
                }

                currentItem.children[2].fnCopy(_visibleCurrentItem.children[0])
                //highlighter.x = _visibleCurrentItem.x
                highlighter.y = _visibleCurrentItem.y
                //highlighter.color = "#ECECEC"


            } else if (
                       (currentItem.y - contentY >= 0
                        && currentItem.y + currentItem.height - contentY < lst_view.height)
                       && _visibleCurrentItem) {
                _visibleCurrentItem.destroy()
                //highlighter.color = "transparent"
            }

            if (!_visibleCurrentItem) {
                highlighter.y = currentItem.y - contentY
            } else {
                highlighter.y = _visibleCurrentItem.y
            }


        }


        onContentHeightChanged: {
            if (lst_view.height > 0)
                verticalScrollBar.maximumValue = lst_view.contentHeight >= lst_view.height? lst_view.contentHeight-lst_view.height:0;
        }

        onHeightChanged: {
            if (lst_view.height > 0)
                verticalScrollBar.maximumValue = lst_view.contentHeight >= lst_view.height? lst_view.contentHeight-lst_view.height:0;
        }
    }

    ScrollBar {
        id: verticalScrollBar
        z:1
        height: lst_view.height
        anchors.right: lst_view.right
        anchors.rightMargin: 20
        opacity: lst_view.contentHeight > lst_view.height
        orientation: Qt.Vertical
        maximumValue: lst_view.contentHeight > lst_view.height? lst_view.contentHeight-lst_view.height:0
        minimumValue: 0
        property bool blockupdates: false

        onValueChanged: {
            if (!blockupdates) {
                lst_view.contentY = value;
            }
        }
        Behavior on opacity {
            NumberAnimation { duration: 300}
        }

    }

    Item {
        id: highlighter
        width: parent.width - 5
        height: 84
        opacity: 0
        z:1

        Image {
            anchors.right: parent.right
            anchors.rightMargin: -10
            anchors.verticalCenter: parent.verticalCenter
            source: "content/clientselectarrow.png"
            visible: stateMaschine.personMenuState.isActive
        }

        Behavior on y {
            id: behavior
            enabled: false
            NumberAnimation { easing.type: Easing.InOutQuart;duration:500}

        }

        Behavior on opacity {
            NumberAnimation {
                duration: 300
            }
        }

    }

    Component {
        id: comp_persondelegatesmall
        Rectangle {

            width: parent.width - 5
            height: 84
            color:"#ECECEC"
            z:0
            Behavior on opacity {
                NumberAnimation {
                    duration: 300
                }
            }
            PersonDelegateSmall {

            }

//            Rectangle {
//                anchors.horizontalCenter: parent.horizontalCenter
//                anchors.verticalCenter: parent.verticalCenter
//                width: 50
//                height: 50
//                visible: stateMaschine.groupMenuState.isActive
//                color: "grey"
//                opacity: 0.75

//                DragArea {
//                    anchors.fill: parent
//                    delegate: comp_persondragdelegate
//                    supportedActions: Qt.LinkAction
//                    autoStart: true
//                    data {
//                        text: id
//                        source: parent
//                    }
//                    onDrop: {
//                        console.log("Drag Area: target accepted the drop with action : " + action)
//                        parent.opacity = 0.75
//                    }

//                    onDragStarted: {
//                        parent.opacity = 0

//                    }
//                }
//            }
        }
    }

    Component {
        id: comp_persondragdelegate
        Rectangle {
            width: 50; height: 50;
            color: "grey";
            opacity: 0.75;

            rotation: 30

        }
    }
}
