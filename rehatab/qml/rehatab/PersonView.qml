// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import QtDesktop 0.1


Item {

    Row {
        id:personViewHeader
        height: 40
        //anchors.top: parent.top
        //visible: stateMaschine.personListViewState.isActive
        Button {
            text: "Neuer Klient"
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                personDetailView.createPerson()
                stateMaschine.newPerson();
            }
        }

        states: [
            State {
                name: "hidden"
                when: !stateMaschine.personListViewState.isActive
                AnchorChanges {
                    target: personViewHeader
                    anchors.top:parent.parent.top
                }
            },
            State {
                name: "shown"
                when: stateMaschine.personListViewState.isActive
                AnchorChanges {
                    target: personViewHeader
                    anchors.top:parent.top
                }
            }

        ]

        transitions: [
            Transition {
            AnchorAnimation {
                duration: 200
            }
            }

        ]

    }

    Rectangle {
        id: personView
        color: myPalette.buttonBg
        border.width: 2
        border.color: myPalette.buttonBorder
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.topMargin: 40
        anchors.bottomMargin: 1
        anchors.rightMargin: 1
        anchors.leftMargin: 1
        PersonGrid {
            id: personGrid
            anchors.fill: parent
            enabled: !stateMaschine.modal
            onMySelectedPersonChanged: {
                if (selectedPerson) {
                    personDetailView.state = "show"
                    var person = model.findById(personId);
                    console.debug("load person " + person);

                    personDetailView.loadPersonDetail(person)
                }

            }
            onContentYChanged: {
                verticalScrollBar.blockupdates = true
                verticalScrollBar.value = contentY
                verticalScrollBar.blockupdates = false
            }

            onContentHeightChanged: {
                if (personGrid.height > 0)
                    verticalScrollBar.maximumValue = personGrid.contentHeight >= personGrid.height? personGrid.contentHeight-personGrid.height:0;
            }

            onHeightChanged: {
                if (personGrid.height > 0)
                    verticalScrollBar.maximumValue = personGrid.contentHeight >= personGrid.height? personGrid.contentHeight-personGrid.height:0;
            }



        }

        ScrollBar {
            id: verticalScrollBar
            height: personGrid.height
            anchors.left: personGrid.right
            opacity: personGrid.contentHeight > personGrid.height
            enabled: !stateMaschine.modal
            orientation: Qt.Vertical
            maximumValue: personGrid.contentHeight > personGrid.height? personGrid.contentHeight-personGrid.height:0
            minimumValue: 0
            property bool blockupdates: false
            onValueChanged: {
                if (!blockupdates) {
                    personGrid.contentY = value;
                }
            }
            Behavior on opacity {
                NumberAnimation { duration: 300}
            }

        }

//        Rectangle {
//            anchors {
//                bottom: parent.bottom
//                right: parent.right
//                left: parent.left
//                margins: 2
//            }

//            height: 56
//            opacity: 0.5
//            color: myPalette.buttonBorder

//        }

//        Row {
//            enabled: !stateMaschine.modal
//            anchors {
//                bottom: parent.bottom
//                left: parent.left
//                leftMargin: 20
//                bottomMargin: 5
//            }
//            spacing: 0

//            Button {
//                height: 50
//                width: 50
//                Image {
//                    anchors.verticalCenter: parent.verticalCenter
//                    anchors.horizontalCenter: parent.horizontalCenter
//                    source: "content/button-add.png"
//                    width: 48
//                    height: 48
//                }
//                onClicked: {
//                    personDetailView.createPerson()
//                    stateMaschine.newPerson();
//                }
//            }
//            Button {
//                height: 50
//                width: 50
//                Image {
//                    anchors.verticalCenter: parent.verticalCenter
//                    anchors.horizontalCenter: parent.horizontalCenter
//                    source: "content/button-remove.png"
//                    width: 48
//                    height: 48
//                }
//                onClicked: {
//                    personController.removePersons(personGrid.selectionModel().selectedIds())
//                }
//            }
//            TextField {
//                Timer {
//                    id: updateTimer
//                    interval: 500
//                    onTriggered: {
//                        personController.personList().filter(parent.text)
//                    }
//                }

//                onTextChanged: {
//                    updateTimer.stop();
//                    updateTimer.start();
//                }
//            }
//        }

    }
    PersonDetailView {
        id: personDetailView
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.fill: parent
        state: "hide"

    }
}
