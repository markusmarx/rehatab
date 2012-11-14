// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import QtDesktop 0.1
import Rehatab 1.0

Column {

    property bool isDirty: false
    property Item editedItem
    property Person personObj

    function savePerson() {
        //var person = personController.activePerson()

        var name = wName.text.split(",")
        personObj.name = name[0].trim()
        personObj.forename = name[1].trim()
        personObj.birth = Util.parseDate(wBirth.text);

        contact_list.saveItem();
        //appointment_list.saveItem();
        clientController.savePerson(personObj)
        isDirty = false;
    }

    function closeDialog() {
        if (personGrid.selectedPerson) {
            personGrid.selectedPerson.state = "small"
        }

        stateMaschine.closePerson();
        personController.clearActivePerson();
        personGrid.forceActiveFocus()

    }

    function loadPersonDetail(aPerson) {
        clearFields()
        personController.loadPerson(aPerson.id)
        personObj = clientController.loadPerson(aPerson)
        personObj = aPerson
        wName.text = personObj.name + ", " + personObj.forename
        wBirth.text = Util.formatDate(personObj.birth)
        wAge.text = personObj.age
        isDirty = false
        contract_list.loadItems(personObj.contracts)
        appointment_list.loadItems(personObj.appointments)
    }

    function clearFields() {
        wName.text = ""
        wBirth.text = ""
        wAge.text = ""
        wName.forceActiveFocus()
    }

    function createPerson() {
        clearFields()
        personObj = clientController.createPerson();
        isDirty = true;
        contract_list.loadItems(personObj);
    }

    Row {
        id:personViewHeader
        height: 40
        anchors.top:parent.top
        smooth: true
        Button {
            text: "Speichern"
            anchors.verticalCenter: parent.verticalCenter
            onClicked: savePerson();
            visible: isDirty

        }
        Button {
            text: "Abbrechen"
            anchors.verticalCenter: parent.verticalCenter
            onXChanged: console.log("x " + x);
            onClicked:
            {
                closeDialog();
            }
        }
        Button {
            anchors.verticalCenter: parent.verticalCenter

            text: qsTr("Neuer Vertrag")
            onClicked:  {
                isDirty = true
                var contract = clientController.createContract()
                contract.client = personObj
                contact_list.newItem(contract)
            }
        }

        Button {
            anchors.verticalCenter: parent.verticalCenter

            text: qsTr("Neuer Termin")
            onClicked:  {
                isDirty = true
                var clAppSum = clientController.createClientAppointmentSummary()
                clAppSum.client = personObj
                appointment_list.newItem(clAppSum)
            }
        }

        move: Transition {
                           NumberAnimation {
                               properties: "x"
                               easing: Easing.Linear
                          duration: 150
                           }
                       }

    }

    /* Persondetail name, birth, picture
     *
     */

    Rectangle {
        id: rectangle1

        anchors.top: personViewHeader.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        color: "#48add4"
        radius: 0
        border.color: "#d9eef6"
        border.width: 2

        MouseArea {
            anchors.fill: parent
        }

        /**
      * Top Details (Picture, Name, Birth, ..)
      */

        Item {
            id: item1
            height: 180
            Image {
                id: personImage
                source: "content/user.png"
                width: 130
                height: 134
            }

            Label {
                id:lbName
                font: myFont.label
                color: "white"
                anchors.left: personImage.right
                anchors.top: parent.top
                anchors.topMargin: 10
                text: qsTr("Nachname, Vorname")
            }
            TextField {
                id:wName
                font: myFont.textinput
                width: 500
                anchors.top: lbName.bottom
                anchors.topMargin: 5
                anchors.left: personImage.right
                KeyNavigation.tab: wBirth
                onTextChanged: isDirty = true
            }

            Label {
                anchors.top: wName.bottom
                anchors.left: personImage.right
                anchors.topMargin: 10
                color: "white"
                id:lbBirth
                text: qsTr("Geburtstag")
                font: myFont.label
            }
            TextField {
                id:wBirth
                width: 130
                font: myFont.textinput
                anchors.top: lbBirth.bottom
                anchors.topMargin: 5
                anchors.left: personImage.right
                //inputMask: "99.99.9999"
                placeholderText: Util.dateFormat
                KeyNavigation.tab: wAilment

                onActiveFocusChanged: {
                    cursorPosition = 0
                }
                onTextChanged: {
                    if (personController.activePerson()) {
                        personController.activePerson().birth = Util.parseDate(wBirth.text);
                        wAge.text = personController.activePerson().age
                    }
                }

            }
            Label {
                color: "white"
                anchors.top: wName.bottom
                anchors.topMargin: 10
                anchors.left: wBirth.right
                anchors.leftMargin: 10

                id:lbAge
                text: qsTr("Alter")
                font: myFont.label
            }
            Text {
                id:wAge
                width: 50
                font: myFont.textinput
                anchors.top: lbAge.bottom
                anchors.topMargin: 9
                anchors.left: wBirth.right
                anchors.leftMargin: 10
            }

            Label {
                anchors.top: wName.bottom
                anchors.topMargin: 10
                anchors.left: wAge.right
                anchors.leftMargin: 10
                color: "white"
                id:lbAilment
                text: qsTr("Krankheitsbild")
                font: myFont.label
            }
            TextField {
                id:wAilment
                width: 150

                font: myFont.textinput
                anchors.top: lbAilment.bottom
                anchors.topMargin: 5
                anchors.left: wAge.right
                anchors.leftMargin: 10
                anchors.right: wName.right

            }

        }


        /*
      * Detail Tab
      */
        Item {
            anchors.top: item1.bottom
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            Column {
                anchors.fill: parent
                ListView {
                    id:personDetail_attrtab
                    height: 20
                    width: 300
                    orientation: ListView.Horizontal
                    interactive: false
                    onCurrentIndexChanged: {
                        personDetail_attrview.currentIndex = currentIndex;
                    }

                        model: ListModel {
                            ListElement {
                                name: "Kontaktinfo"
                            }
                            ListElement {
                                name: "Verträge"
                                isVisible: true
                            }
                            ListElement {
                                name: "Termine"
                                isVisible: true
                            }
                        }


                        delegate:
                            Text {
                                text: name
                                visible: isVisible
                            }

                        highlight: Rectangle { color: "lightsteelblue"}

                        MouseArea {
                            anchors.fill: parent
                            onClicked: parent.currentIndex = parent.indexAt(mouse.x, mouse.y);
                            }
                        }




                ListView {
                    id: personDetail_attrview
                    property bool blocked: false

                    width:parent.width
                    anchors.bottom: parent.bottom
                    anchors.top: personDetail_attrtab.bottom
                    orientation: ListView.Horizontal
                    snapMode: ListView.SnapOneItem

                    onContentXChanged: {
                        console.debug(currentIndex)
                        blocked = true
                        personDetail_attrtab.currentIndex = currentIndex;
                        blocked = false
                    }
                    highlightMoveDuration: 300

                    model: VisualItemModel {
                        MasterDetailList {
                            id:contact_list
                            width: ListView.view.width
                            height: ListView.view.height
                            dialogDelegate: AppointmentEdit {
                                id: contactEdit
                            }
                            listDelegate: Text {
                                text: Util.formatDate(validFrom) + " - " + Util.formatDate(validTo)
                            }
                        }
                        MasterDetailList {
                            id:contract_list
                            width: ListView.view.width
                            height: ListView.view.height
                            dialogDelegate: ContractEdit {
                                id: contractEdit
                            }
                            listDelegate: Text {
                                text: Util.formatDate(validFrom) + " - " + Util.formatDate(validTo)
                            }
                        }
                        MasterDetailList {
                            id:appointment_list
                            width: ListView.view.width
                            height: ListView.view.height
                            dialogDelegate: AppointmentEdit {
                                id: appointmentEdit
                            }
                            listDelegate: Text {
                                text: Util.formatDate(validFrom) + " - " + Util.formatDate(validTo)
                            }
                        }

                    }
                }


            }
        }

    }


    transitions: [
        Transition {
            to: "show"
            NumberAnimation {
                target: personDetailView
                properties: "opacity"
                duration: 1000
                easing.type: "InExpo"
            }
        },
        Transition {
            to: "hide"
            NumberAnimation {
                target: personDetailView
                properties: "opacity"
                duration: 500
                easing.type: "OutQuad"
            }
        },
        Transition {
            to: "showNew"
            NumberAnimation {
                target: personDetailView
                properties: "opacity"
                duration: 500
                easing.type: "InQuad"
            }
        }

    ]

    states: [
        State {
            name: "show"
            when: stateMaschine.openPersonState.isActive
            PropertyChanges {
                target: personDetailView
                opacity: 1
            }

        },
        State {
            name: "showNew"
            when: stateMaschine.newPersonState.isActive

            PropertyChanges {
                target: personDetailView
                opacity: 1

            }

        },
        State {
            name: "hide"
            when: !stateMaschine.openPersonState.isActive
            PropertyChanges {
                target: personDetailView
                opacity: 0
            }

        }


    ]


}
