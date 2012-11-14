// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

GridView {
    id: personGrid
    property Item selectedPerson
    signal mySelectedPersonChanged(int personId)
    clip: true
    flow: GridView.LeftToRight
    property int oldX
    property int oldY

    cellHeight: 116
    cellWidth: 246
    model: personList
    delegate: Flipable {
        id:personCard
        width: 246
        height: 106


        transform: Rotation {
            id: rotation

            origin.x: personCard.width/ 2
            origin.y: personCard.height/2
            axis {x:0; z:0; y:1}
            angle:0
        }

        front: PersonDelegateSmall {

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (personGrid.selectedPerson) {
                        personGrid.selectedPerson.state = "small"
                    }
                    oldX = personCard.x
                    oldY = personCard.y
                    personCard.state = "detail"
                    personGrid.selectedPerson = personCard
                    console.log(parent.modelId)
                    mySelectedPersonChanged(parent.modelId)
                }
            }
        }
        back: Item {
            width: personCard.width
            height: personCard.height
            Rectangle {
                anchors.fill:parent
                anchors.margins: 10
                color: "#48add4"
                radius: 5
                border.color: "#48add4"
                border.width: 5
            }
        }

        states: [
            State {

                name: "detail"

                PropertyChanges {
                    target: rotation; angle: 180
                }
                ParentChange {
                    target: personCard
                    parent: personView
                }

            },
            State {
                name: "small"
                PropertyChanges {
                    target: rotation; angle: 0
                }
                ParentChange {
                    target: personCard
                    parent: personGrid
                }

            }
        ]
        transitions: [
            Transition {

                to: "detail"


                    SequentialAnimation {

                        NumberAnimation {
                            target: personCard
                            properties: "y"; to: personCard.y-15
                            easing.type: "OutSine"
                            duration: 300

                        }
                        ParallelAnimation {
                            NumberAnimation {
                                target: personCard
                                properties: "y"; to: personGrid.height/2 - personCard.height/2
                                easing.type: "OutCubic"
                                duration: 300

                            }

                            NumberAnimation {
                                target: personCard
                                properties: "x"; to: personGrid.width/2 - personCard.width/2
                                easing.type: "InCubic"
                                duration: 300

                            }
                        }
                        NumberAnimation { target: rotation; properties: "angle"; duration: 200}


                }
            },
            Transition {

                to: "small"
                ParallelAnimation {
                    NumberAnimation { target: rotation; properties: "angle"; duration: 200}
                    SequentialAnimation {

                        NumberAnimation {
                            target: personCard
                            properties: "y"; to: personCard.y-15
                            easing.type: "OutSine"
                            duration: 300

                        }
                        ParallelAnimation {
                            NumberAnimation {
                                target: personCard
                                properties: "y"; to: oldY
                                easing.type: "InCubic"
                                duration: 300

                            }

                            NumberAnimation {
                                target: personCard
                                properties: "x"; to: oldX
                                easing.type: "OutCubic"
                                duration: 300

                            }
                        }

                    }
                }
            }


        ]
    }

}
