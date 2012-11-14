// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: personView
    color: myPalette.buttonBg
    border.width: 4
    border.color: myPalette.buttonBorder

    PersonGrid {
        id: personGrid
        anchors.fill: parent

        onMySelectedPersonChanged: {
            if (selectedPerson) {
                personDetailView.state = "show"

                personDetailView.loadPersonDetail(personId)
            }

        }
    }

    PersonDetailView {
        id: personDetailView
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: 876
        height: 452
        state: "hide"

        transitions: [
            Transition {
                from: "hide"
                to: "show"
                NumberAnimation {
                    target: personDetailView
                    properties: "opacity"
                    duration: 1000
                    easing.type: "InExpo"
                }
            },
            Transition {
                from: "show"
                to: "hide"
                NumberAnimation {
                    target: personDetailView
                    properties: "opacity"
                    duration: 900
                    easing.type: "OutQuad"
                }
            }

        ]

        states: [
            State {
                name: "show"
                PropertyChanges {
                    target: personDetailView
                    opacity: 1
                }

            },
            State {
                name: "hide"
                PropertyChanges {
                    target: personDetailView
                    opacity: 0
                }

            }


        ]

    }

}
