import QtQuick 1.1
import QtDesktop 0.1
import Rehatab 1.0
import QmlFeatures 1.0

Rectangle {
    id: calClientAppointmentEdit
    signal close()

    function fnCloseDialog() {
        close();
    }

    FocusScope {
        anchors.fill: parent

        Column {
            id: groupform_input
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right


            Row {

                Button {
                    text: "Termin speichern"
                    onClicked: {
                        focus = true

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
        }
    }
}
