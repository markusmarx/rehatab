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
        comp_contractedit.createObject(parent, {personObj: _person})
    }

    Rectangle {
        anchors.fill: parent
        color: main_style.navigationBg
    }

    Row {
        id: btnbar_clientoverview
        anchors.top:parent.top
        anchors.left:parent.left
        anchors.right: parent.right
        Button {
            text: "Stammdaten editieren"
        }
        Button {
            text: "Vertrag anlegen"
            onClicked: fnNewContract()
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
            delegate: Rectangle {
                color: yellow
                width: 150
                height: 50
                Text {anchors.fill: parent; text: validFrom + ", " + validTo}

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
