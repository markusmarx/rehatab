// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import QtDesktop 0.1
import Rehatab 1.0
Item {
    id:personSelector
    property Person person
    property Item popup;
    property Item popupParent;
    property alias model: personModel
    height: 30

    signal chooseItem()

    onPersonChanged: {
        if (person) {
            personInput.text = person.name+ ", " + person.forename
        }
        popup.state = "hidden"
    }

    function clear() {
        personInput.text = "";
    }

    PersonList {
        id: personModel
        Component.onCompleted: {
            reload();
        }
    }

    TextField {
        id:personInput
        anchors.fill: parent
        onTextChanged: {

            if (popup.state != "visible") {
                popup.state = "visible";
            }

            personModel.filter(personInput.text)

        }

        Keys.onDownPressed: {
            popup.incrementIdx();
        }

        Keys.onUpPressed: {
            popup.decrementIdx();
        }

        Keys.onReturnPressed: {
            if (personInput.text != "" && person) {
                chooseItem();
            } else if (popup.state == "visible") {
                person = popup.chooseItem();
            }
        }

        Keys.onEscapePressed: {
            popup.state = "hidden";
            personInput.text = "";
            personSelector.parent.forceActiveFocus();
        }

        onActiveFocusChanged: {
            if (!popup) {
                popup = personListComponent.createObject(popupParent)
                var p = mapToItem(popup, personInput.pos.x, personInput.pos.y)
                popup.x = p.x
                popup.y = p.y+personInput.height
                popup.width = personSelector.width
                popup.state = "hidden"
                popup.opacity = 0
            }

            if (personInput.focus) {
                //popup.state = "visible"
            } else {
                popup.state = "hidden"
            }
        }

    }

    Component {
        id: personListComponent
        Rectangle {
            height: 0
            color: "#dbdbdb"
            state: "hidden"

            function incrementIdx() {
                personListView.incrementCurrentIndex();
            }
            function decrementIdx() {
                personListView.decrementCurrentIndex();
            }
            function chooseItem() {
                return personController.loadPerson(personListView.currentItem.pid);
            }

            ListView {
                id: personListView
                anchors.fill: parent
                model: personModel
                highlight: Rectangle {
                    color: "#bfd2fb"
                }

                delegate:


                    Text {
                    text: name+ ", " + forename
                    width: ListView.view.width
                    property int pid: personId
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            person = personController.loadPerson(personId)
                            personSelector.chooseItem();

                        }
                    }

                }
            }
            states: [
                State {
                    name: "visible"
                    PropertyChanges {
                        target: popup
                        height: personListView.contentHeight < 100? personListView.contentHeight: 100;

                    }
                    PropertyChanges {
                        target: popup
                        opacity: 1

                    }
                },
                State {
                    name: "hidden"
                    PropertyChanges {
                        target: popup
                        height: 0

                    }
                    PropertyChanges {
                        target: popup
                        opacity: 0

                    }
                }
            ]

            transitions: Transition {
                SequentialAnimation {
                    PropertyAnimation {
                        target:popup
                        properties: "height, opacity"
                        duration: 200
                    }
                }

            }
        }
    }


}
