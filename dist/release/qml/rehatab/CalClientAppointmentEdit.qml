import QtQuick 1.1
import QtDesktop 0.1
import Rehatab 1.0
import QmlFeatures 1.0

Rectangle {
    id: calClientAppointmentEdit
    property PersonAppointment _personAppointment
    property date currentDate;

    signal close()

    function fnCloseDialog() {
        close();
    }


    function fnSetFields() {
        label_name.text = _personAppointment.client.name + ", " + _personAppointment.client.forename
    }

    function fnSaveGroup() {
        appointmentController.savePersonAppointment(_personAppointment, currentDate)
        fnCloseDialog()
    }

    FocusScope {
        anchors.fill: parent

        Column {
            id: input_calclient
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                leftMargin: 10
            }
            spacing: 10

            Row {

                Button {
                    text: "Termin speichern"
                    onClicked: {
                        focus = true
                        fnSaveGroup()
                    }
                }

                Button {
                    text: "Dialog schließen"
                    onClicked: {
                        focus = true
                        fnCloseDialog();
                    }
                }
            }

            LabelLayout {
                labelPos: Qt.AlignTop

                SimpleFormLabel {
                    text: "Name"
                }
                Text {
                    id: label_name
                    font {
                        family: main_style.defaultInputFont.family
                        pixelSize: main_style.defaultInputFont.size
                    }
                }
            }
        }
        Item {
            id:calclient_client
            anchors {
                top:input_calclient.bottom
                topMargin: 20
                leftMargin: 10
            }


            width: delegate.width
            height: delegate.height

            property Person _person
            property Contract _contract

            Component.onCompleted: {
                _person = _personAppointment.client;
                _contract = clientController.loadContract(_personAppointment.contract);
                delegate.name = _person.name
                delegate.forename = _person.forename
                delegate.birth = _person.birth
                delegate.age = _person.age
            }

            PersonDelegateSmall {
                id: delegate
            }

            CheckBox {
                checked: calclient_client._person.presence
                onCheckedChanged: {
                    calclient_client._person.presence = checked
                    if (checked) {
                        calclient_client._contract.openValue -= 1
                    } else {
                        calclient_client._contract.openValue += 1
                    }
                }
            }
            Text {
                anchors.top: delegate.bottom
                anchors.topMargin: 10
                anchors.left: delegate.left
                anchors.leftMargin: 10
                text: calclient_client._contract.openValue + " offene Sitzungen"
                font.family: main_style.header2Font.family
                font.pixelSize: main_style.header2Font.size
                color: main_style.header2Font.color
            }



        }

    }
}
