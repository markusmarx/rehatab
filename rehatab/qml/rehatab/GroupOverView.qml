import QtQuick 1.1
import QtDesktop 0.1
import QmlFeatures 1.0
import Rehatab 1.0
Item {
    id: group_overview
    anchors.fill: parent



    function fnLinkPersonToGroup(personId, groupId) {
        console.log("link person " + personId + " to " + groupId)
        groupController.addPersonToGroup(clientController.loadPerson(clientController.getPerson(personId)),
                                         groupController.allGroups().findById(groupId));
    }


    Row {
        id:btn_groupoverview
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        Button {
            text: "Neue Gruppe"
            onClicked: fnNewGroup()
        }
    }

    Item {
        id:groupoverview_contentarea
        anchors.top: btn_groupoverview.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        Grid {
            spacing: 10
            anchors.fill: parent
            Repeater {
                model: groupController.allGroups()
                delegate: Rectangle {
                    width: 200
                    height: 200
                    color: "grey"
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        text:name}
                    Text {
                        anchors.bottom: parent.bottom
                        text: clientCount + " Mitglieder"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            fnOpenGroupForm(id)
                        }
                    }

                    DropArea {
                        id: aDropArea
                        anchors.fill: parent
                        onDragEnter: {
                            parent.color = "white"

                        }
                        onDragLeave: {
                            parent.color = "grey"
                        }

                        onDrop: {
                            event.accept(Qt.LinkAction);
                            var contractList = clientController.getContracts(event.data.text)
                            //comp_contractList.createObject(group_overview, {list: contractList})
                            fnLinkPersonToGroup(event.data.text, id)
                            parent.color = "grey"
                        }
                    }
                }
            }
        }
    }


    Component {
        id: comp_contractList
        ListView {
            width: 200
            height: 200
            property alias list: objectModel.list
            model: QObjectListModel {
                id:objectModel
                names: ["validFrom", "validTo"]
            }

            delegate: Text {
                text: validFrom
            }

        }
    }

}





