// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import QtDesktop 0.1
import Rehatab 1.0

Rectangle {
    width: 1024
    height: 768
    color: "#48add4"
    radius: 0
    border.color: "#d9eef6"
    border.width: 2
    property Person person: Person {}
    function loadPersonDetail(id) {
        person.loadId(id)
        wName.text = person.name + ", " + person.forename
        wBirth.text = Qt.formatDate(person.birthDate, "dd.MM.yyyy")
        wAge.text = person.age
    }


    /**
      * Top Details (Picture, Name, Birth, ..)
      */
    Item {
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
            inputMask: "99.99.9999"
            KeyNavigation.tab: wAilment
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

    Column {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 20
        anchors.rightMargin: 20
        spacing: 20

        Button {

            iconSource: "content/button-check.png"

            text: qsTr("Speichern")

            onClicked: {

                personDetailView.state = "hide"
                personGrid.selectedPerson.state = "small"
            }

        }

        Button {
            text: qsTr("Abbrechen")
            onClicked: {

                personDetailView.state = "hide"
                personGrid.selectedPerson.state = "small"
            }

        }
        Button {
            text: qsTr("Löschen")
            onClicked: {

                personDetailView.state = "hide"
                personGrid.selectedPerson.state = "small"
            }


        }


        //        Button {
        //            imageurl: "content/button-cross.png"
        //            MouseArea {
        //                anchors.fill: parent
        //                onClicked: {

        //                    personDetailView.state = "hide"
        //                    personGrid.selectedPerson.state = "small"
        //                }
        //            }
        //        }
        //        Button {
        //            imageurl: "content/button-check.png"
        //        }

    }
}
