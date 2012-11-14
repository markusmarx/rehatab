import QtQuick 1.1
import QtDesktop 0.1
import Rehatab 1.0
Rectangle {
    id:appointmentDetailView
    property bool isNew: false

    property Appointment appointment

    function newAppointment() {
        appointment = appointmentController.createAppointment();
        read();
        appointmentDetailView.visible = true;
    }

    function loadAppointment(id) {
        appointment = appointmentController.appointmentModel().getAppointment(id)
        read();
        appointmentDetailView.visible = true;
    }

    function addMember(person) {
        if (person) {
            appointment.addMember(person)
        }
        personSelector.clear();
        personSelector.person = null
    }

    function read() {
        dateFrom.text = Qt.formatDate(appointment.fromDate, "dd.MM.yyyy");
        //dateTo.text = Qt.formatDate(appointment.toDate, "dd.MM.yyyy");
        timeFrom.text = Qt.formatTime(appointment.fromTime, "hh:mm");
        //timeTo.text = Qt.formatTime(appointment.toTime, "hh:mm");
        name.text = appointment.name;
//        personSelector.person = null
//        personSelector.model.reload();

    }

    function write() {
        appointment.name = name.text;
        appointment.fromDate = Util.parseDate(dateFrom.text);
        appointment.fromTime = Util.parseTime(timeFrom.text);
        appointment.itStart = appointment.fromDate
        appointment.minutes = parseInt(wMinutes.text);
        appointment.itModel = iteration.text;
    }

    width: 1024
    height: 768
    color: "#48add4"
    radius: 0
    border.color: "#d9eef6"
    border.width: 2
    FocusScope {

        Column {
            id: appoCommon
            TextField {
                id:name
                width: 400
            }

            Row {
                TextField {
                    id:dateFrom
                    width: 100
                    placeholderText: "dd.mm.yyyy"
                }
                TextField {
                    id:timeFrom
                    width: 50
                    placeholderText: "hh:mm"
                }
                TextField {
                    id: wMinutes
                    width: 50
                    placeholderText: "mm"
                }

                TextField {
                    id:iteration
                    width: 100
                    text: "w 2 13"
                }


            }

        }

//        Column {
//            id: appoMember
//            anchors.left: appoCommon.right
//            Row {
//            PersonSelector {
//                id:personSelector
//                width: 250
//                popupParent: appointmentDetailView
//                onChooseItem: {
//                    addMember(personSelector.person)

//                }
//            }
//            Button {
//                text: qsTr("Hinzufügen")
//                onClicked: {
//                    addMember(personSelector.person);
//                }
//            }
//            }
//            Rectangle {
//                y:400
//                width: 250
//                height: 250


//                ListView {

//                    anchors.fill: parent
//                    model:appointment.member
//                    delegate: Item {
//                        height: 20
//                        width: parent.width
//                        CheckBox {
//                            id: checkbox
//                            width: 30
//                            checked: appointment.isPresent(id)
//                            onCheckedChanged: {
//                                appointment.setPresent(id, checked);
//                            }
//                        }
//                        Text {
//                            anchors.right: btDelete.left
//                            anchors.left: checkbox.right
//                        text: name + ", " + forename
//                        }
//                        Text {
//                            id: btDelete
//                            anchors {
//                                right: parent.right

//                            }
//                            text: "x"
//                            MouseArea {
//                                anchors.fill: parent
//                                onClicked: appointment.member.remove(appointment.member.find("id", id))
//                            }
//                        }
//                    }
//                }

//            }
//        }



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
                write();
                appointmentController.saveAppointment(appointment)
                appointmentDetailView.visible = false
            }

        }

        Button {
            text: qsTr("Abbrechen")
            onClicked: {
                appointmentDetailView.visible = false
            }
        }
        Button {
            text: qsTr("Löschen")
            visible: !isNew
            onClicked: {
                appointmentDetailView.visible = false

            }


        }

    }
}
