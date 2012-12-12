// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import Rehatab 1.0
import QtDesktop 0.1
Rectangle {
    id: calendarDayView
    color:"white"
    border.color: "white"
    width: calendarTimeline.width
    height: calendarTimeline.height
    property date day
    signal appointmentDoubleClicked(int id);


//    anchors.left: parent.left
//    anchors.right: parent.right
    property bool active: true
    property bool showTime: false


    CalendarTimeLine {
        id: calendarTimeline
        date: day
        renderTime: calendarDayView.showTime
        gridWidth: calendarView.gridWidth
        gridHeight: calendarView.gridHeight
        appointmentModel: appointmentController.appointmentModel()

        anchors {
            top:parent.top

        }
        delegate: Rectangle {
            color: "blue"
            opacity: 0.5
            property string name//: CalendarTimeLine.name
            property variant from//: CalendarTimeLine.from
            property variant to//: CalendarTimeLine.to
            property int id
            Column {
                anchors.fill: parent

                Text {
                    text: Qt.formatTime(from, "hh:mm") + " - " +Qt.formatTime(to, "hh:mm")
                    anchors.rightMargin: 10
                }

                Text {
                    text: name
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    fnOpenAppointment(id, date, from)
                }
            }
            CursorArea {
                anchors.fill: parent
                cursor: CursorArea.PointingHandCursor
            }
        }
    }


}
