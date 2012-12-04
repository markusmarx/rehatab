import QtQuick 1.1
import QtDesktop 0.1
import Rehatab 1.0
import QmlFeatures 1.0
import "common/FormUtils.js" as FormUtils
import "common"

Rectangle {
    id: clientAppointmentEdit
    property Person personObj
    property PersonAppointment _personAppointment
    property bool formError: false

    function fnCloseForm() {
        clientAppointmentEdit.destroy()
    }

    function fnSaveForm() {
        var inputList = new Array(input_timeselection);

        if (FormUtils.fnValidateForm(inputList)) {

            if (!Qt.isQtObject(_personAppointment)) {
                _personAppointment = clientController.createPersonAppointment()
                _personAppointment.appointment.date = input_timeselection.startDate
                _personAppointment.appointment.time = input_timeselection.startTime
                _personAppointment.appointment.minutes = parseInt(input_timeselection.minutes)
                _personAppointment.appointment.iteration = input_timeselection.iteration()

                clientController.savePersonAppointment(_personAppointment, personObj, personObj.contracts.at(0))
            }

        } else {

        }

    }
    

    FocusScope {
        Column {
            anchors.fill: parent
            spacing: 10
            Row {
                Button {
                    text: "Termin speichern"
                    onClicked: {
                        focus = true
                        fnSaveForm();
                    }
                }
                Button {
                    text: "Abbrechen"
                    onClicked: {
                        focus = true
                        fnCloseForm()
                    }
                }
            }
            Text {
                text: "Überprüfen Sie die rot markierten Eingaben! Detailierte Informationen finden Sie an den Eingaben."
                color: "red"
                opacity: formError? 1: 0
            }

            TimeSelection {
                id: input_timeselection
            }

        }

    }

}
