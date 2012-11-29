import QtQuick 1.1
import Rehatab 1.0
import QtDesktop 0.1
import QmlFeatures 1.0

Item {
    id: client_overview

    property Person _person

    function fnLoadClient(personId) {
        _person = personController.loadPerson(personId)
        clientController.loadPerson(_person)
    }

    function fnNewContract() {
        comp_contractedit.createObject(pag_contentarea, {personObj: _person})
    }

    function fnEditClient() {
        comp_clientform.createObject(pag_contentarea, {personObj: _person});
    }

    function fnDeleteClient() {
        lst_view.fnClearSelection()
        clientController.removePerson(_person)
        fnOpenCloseClientOverView(false)
    }

    Rectangle {
        anchors.fill: parent
        color: "white"
    }

    Row {
        id: btnbar_clientoverview
        anchors.top:parent.top
        anchors.left:parent.left
        anchors.right: parent.right
        Button {
            text: "Stammdaten editieren"
            onClicked: fnEditClient()
        }
        Button {
            text: "Vertrag anlegen"
            onClicked: fnNewContract()
        }
        Button {
            text: "Klient löschen"
            onClicked: fnDeleteClient()
        }
    }

    Rectangle {
        id: info_clientdata
        anchors.top: btnbar_clientoverview.bottom
        anchors.left: parent.left
        anchors.right: parent.horizontalCenter
        anchors.rightMargin: 5
        anchors.leftMargin: 10
        height: 200
        Column {
            LabelLayout {
                Label { text: "Name, Vorname"}
                Text {
                    text: _person.name +"," + _person.forename
                }
            }
        }

    }

    Rectangle {
        id:info_appointment
        anchors.top: btnbar_clientoverview.bottom
        anchors.left: parent.horizontalCenter
        anchors.leftMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 10
        height: 200
        Column {
            Text {
                text: _person.name +"," + _person.forename
            }
        }

    }

    Rectangle {
        anchors.top: info_clientdata.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.topMargin: 10
        anchors.rightMargin: 10
        anchors.leftMargin: 10

        ListView {
            anchors.fill: parent
            model: _person.contracts
            header: Text {
                text: "Verträge"
            }

            delegate: Rectangle {
                color: "grey"
                width: 200
                height: 50
                Column {
                    Row {
                LabelLayout {
                    labelPos: Qt.AlignTop
                    Label {
                        text: "Startdatum"
                    }
                    Text {
                        text: Qt.formatDate(validFrom, "dd.MM.yyyy")+ " - "
                    }
                }
                LabelLayout {
                    labelPos: Qt.AlignTop
                    Label {
                        text: "Enddatum"
                    }
                    Text {
                        text: Qt.formatDate(validTo, "dd.MM.yyyy")
                    }
                }
                }
                }
//                Text {anchors.fill: parent;
//                    text:
//                          + ", " + Qt.formatDate(validTo, "dd.MM.yyyy") + " ("+openValue+")"}

                MouseArea {
                    anchors.fill: parent

                    onClicked:  {

                    }
                }
            }
        }
    }

    Component {
        id: comp_contractedit
        ContractEdit {
            anchors.fill: parent
        }
    }


}
