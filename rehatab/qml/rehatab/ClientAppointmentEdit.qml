import QtQuick 1.1
import QtDesktop 0.1
import Rehatab 1.0
import QmlFeatures 1.0
import "common/FormUtils.js" as FormUtils
import "common"

Rectangle {
    id: clientAppointmentEdit
    property Person personObj
    property bool formError: false
    function fnCloseForm() {
        clientAppointmentEdit.destroy()
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

            TimeSelection {}

        }

    }

}
