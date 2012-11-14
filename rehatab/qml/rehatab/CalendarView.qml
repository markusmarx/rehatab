// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import QtDesktop 0.1
import Rehatab 1.0
Rectangle {
    id: calendarView
    color: myPalette.buttonBg
    border.width: 4
    border.color: myPalette.buttonBorder
    property int gridWidth: 200
    property int gridHeight: 50

    function fnOpenAppointment(id) {

        var form = comp_groupform.createObject(calendarView, {_group: groupController.loadGroup(groupController.findByAppointmentId(id))});
        form.fnLoadGroup();

    }

    CalendarModel {
        id: calendarModel

        onDateRangeChanged: {
            console.log("daterange changed " + from + "->"+ to);
            appointmentController.loadAppointmentsToModel(from, to);
        }

        Component.onCompleted: {
            console.debug("CalendarModel created.")
            appointmentController.loadAppointmentsToModel(firstDate, lastDate);
        }
    }

    Row {
        id:calButtonHeader
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        Button {
            text: "Vorige Woche"
            onClicked: {
                var cY = calGridView.contentY;
                var cX = calGridView.contentX;

                calendarModel.addWeek(-1);

                calGridView.contentX = cX;
                calGridView.contentY = cY;
            }
        }
        Button {
            text: "Nächste Woche"
            onClicked: {

                var cY = calGridView.contentY;
                var cX = calGridView.contentX;

                calendarModel.addWeek(1);

                calGridView.contentX = cX;
                calGridView.contentY = cY;
            }
        }
    }

    ListView {
        id: calHeader
        property bool blockUpdates: false
        clip: true
        anchors {
            left: parent.left
            leftMargin: 0
            right: parent.right
            top: calButtonHeader.bottom
        }

        onContentXChanged: {
            if (!blockUpdates) {
                blockUpdates = true;
                calGridView.contentX = contentX;
                blockUpdates = false;
            }
        }

        model: calendarModel
        height: 20
        orientation: ListView.Horizontal
        delegate:
            Rectangle {

                width: gridWidth
                color: "#efefef"

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: Qt.formatDate(date, "ddd dd.MM.")

                }
            }
    }

    Flickable{
        id:calGridView
        anchors {
            left: parent.left
            right: parent.right
            top: calHeader.bottom
            bottom: parent.bottom
        }

        anchors {
            leftMargin:4
            rightMargin:4
            topMargin: 4
            bottomMargin: 4
        }

        contentHeight: calendarRow.height+56
        contentWidth: calendarRow.width
        clip: true

        onContentXChanged: {
            if (!calHeader.blockUpdates) {
                calHeader.blockUpdates = true
                calHeader.contentX = contentX;
                calHeader.blockUpdates = false
            }
        }

        Row {
            id: calendarRow
            spacing: 10
            Repeater {
                model: calendarModel

                delegate:
                    CalendarDayView {
                        smooth: false
                        showTime: false
                        day: date


                }
            }

        }
    }

//    Rectangle {
//       anchors {
//           bottom: parent.bottom
//           right: parent.right
//           left: parent.left
//           margins: 2
//       }

//       height: 56
//       opacity: 0.5
//       color: myPalette.buttonBorder

//   }
//    Row {
//        enabled: !stateMaschine.modal
//        anchors {
//            bottom: parent.bottom
//            left: parent.left
//            leftMargin: 20
//            bottomMargin: 5
//        }
//        spacing: 0

//        Button {
//            height: 50
//            width: 50
//            Image {
//                anchors.verticalCenter: parent.verticalCenter
//                anchors.horizontalCenter: parent.horizontalCenter
//                source: "content/button-add.png"
//                width: 48
//                height: 48
//            }
//            onClicked: {
//                appointmentDetailView.newAppointment();

//            }
//        }
//        Button {
//            height: 50
//            width: 50
//            Image {
//                anchors.verticalCenter: parent.verticalCenter
//                anchors.horizontalCenter: parent.horizontalCenter
//                source: "content/button-remove.png"
//                width: 48
//                height: 48
//            }
//            onClicked: {
//                //personController.removePersons(personGrid.selectionModel().selectedIds())
//            }
//        }
//    }

Component {
    id:comp_groupform
    GroupForm {
        id:groupform
        mode: 1
        anchors.fill: parent
        onClose: {
            groupform.destroy()
        }
    }
}
}
