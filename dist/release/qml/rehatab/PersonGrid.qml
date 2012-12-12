// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import Rehatab 1.0
GridView {
    id: personGrid

    property Item selectedPerson
    signal mySelectedPersonChanged(int personId)
    focus: true

    function selectionModel() {
        return personSelectionModel;
    }

    SelectionModel {
        id: personSelectionModel
        currentSelectionFlag: SelectionModel.ClearAndSelect

    }

    Keys.onPressed: {

        if (event.modifiers & Qt.ControlModifier) {
            personSelectionModel.currentSelectionFlag = SelectionModel.Toggle
        }
    }
    Keys.onReleased: {
        personSelectionModel.currentSelectionFlag = SelectionModel.ClearAndSelect
    }

    function select(item) {
        personSelectionModel.select(item.modelId)
    }

    clip: true
    flow: GridView.LeftToRight

    cellHeight: 116
    cellWidth: 246
    model: personController.personList()


    delegate: Flipable {
        id:personCard

        property int oldX
        property int oldY
        property Item oldParent
        property int modelId: id
        property bool selected: personSelectionModel.itemSelection(id).selected


        width: 246
        height: 106

        GridView.onAdd: {
            select(personCard)
            contentY = personCard.y
        }

        GridView.onRemove: SequentialAnimation {
            PropertyAction { target: personCard; property: "GridView.delayRemove"; value: true }
            ParallelAnimation {
                NumberAnimation { target: personCard; property: "opacity"; to: 0; duration: 400; easing.type: Easing.InOutQuad }

            }
            PropertyAction { target: personCard; property: "GridView.delayRemove"; value: false }
        }

        transform: Rotation {
            id: rotation
            origin.x: personCard.width/ 2
            origin.y: personCard.height/2
            axis {x:0; z:0; y:1}
            angle:0
        }

        front: PersonDelegateSmall {
            Behavior on x { NumberAnimation { duration: 400; easing.type: Easing.OutBack } }
            Behavior on y { NumberAnimation { duration: 400; easing.type: Easing.OutBack } }
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
                when: personCard.selected && stateMaschine.openPersonState.isActive
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
                    parent: oldParent
                }

            }
        ]
        transitions: [
            Transition {

                to: "detail"

                ParentAnimation {
                    SequentialAnimation {

//                        NumberAnimation {
//                            target: personCard
//                            properties: "y"; from: personCard.y - (personGrid.contentY);
//                            to: personGrid.height/2 > (personCard.y - (personGrid.contentY))? personCard.y-5 - (personGrid.contentY)
//                                                                                            :personCard.y-5 - (personGrid.contentY)
//                            easing.type: "OutSine"
//                            duration: 300

//                        }
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
                                easing.type: "OutCubic"
                                duration: 300

                            }
                        }
                        ParallelAnimation {
                            NumberAnimation { target: rotation; properties: "angle"; duration: 200}
                            NumberAnimation { target: personCard; properties: "scale"; to: 2; duration: 200;
                                easing.type: "InCubic"}
                        }
                    }
                }},
            Transition {

                to: "small"
                ParentAnimation {
                    ParallelAnimation {

                        SequentialAnimation {
                            ParallelAnimation {
                            NumberAnimation { target: rotation; properties: "angle"; duration: 200}
                            NumberAnimation { target: personCard; properties: "scale"; to: 1; duration: 200;
                                easing.type: "InCubic"}
}
                            ParallelAnimation {
//                                NumberAnimation {
//                                    target: personCard
//                                    properties: "y"; to: oldY-5
//                                    easing.type: "OutSine"
//                                    duration: 300

//                                }

                                NumberAnimation {
                                    target: personCard
                                    properties: "x"; to: oldX
                                    easing.type: "OutCubic"
                                    duration: 300

                                }
                                NumberAnimation {
                                    target: personCard
                                    properties: "y"; to: oldY
                                    easing.type: "OutCubic"
                                    duration: 300

                                }
                            }


                        }
                    }}
            }


        ]
    }

}
