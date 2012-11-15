import QtQuick 1.1
import QmlFeatures 1.0
import QtDesktop 0.1
import Rehatab 1.0

Item {
    id: form_group

    property int weekFlags
    property PersonGroup _group
    property int mode:0
    property date currentDate;
    signal close()

    function fnSaveGroup() {
        if (!Qt.isQtObject(_group)) {
            _group = groupController.createGroup();
        }
        _group.name = input_name.text
        _group.date = input_startDate.date
        _group.time = input_starttime.time
        _group.minutes = parseInt(input_minutes.text)
        var iteration = "w 1 "
        for (var i = 1, k = 1; k <= 7; i=i*2,k++) {
            if (weekFlags & i) {
                iteration += k.toString()
            }
        }

        _group.iteration = iteration;
        if (mode == 1) {
            console.log(currentDate);
            groupController.saveGroup(_group, currentDate)
        } else {
            groupController.saveGroup(_group)
        }
        fnCloseDialog()
    }

    function fnCloseDialog() {
        close();
    }

    function fnLoadGroup() {
        input_name.text = _group.name
        input_startDate.date = _group.date
        input_minutes.text = _group.minutes
        input_starttime.time = _group.time

        for (var i=4; i < _group.iteration.length; i++) {
            weekFlags = weekFlags | Math.pow(2, parseInt(_group.iteration.charAt(i))-1)
        }

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
                    text: "Gruppe anlegen"
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
                Label {
                    text: "Name"
                }
                TextField {
                    id: input_name
                }
            }

            LabelLayout {
                labelPos: Qt.AlignTop
                Label {
                    text: "Started am"
                }


                DateEdit {
                    id:input_startDate
                }

            }

            Row {
                TimeEdit {
                    id:input_starttime
                }
                TextField {
                    id:input_minutes
                    validator: IntValidator {}
                }
            }

            LabelLayout {
                labelPos: Qt.AlignTop
                itemMargin: 10
                Label { text: "Wiederholung jede\nWoche am"}

                Row {
                    id: input_weekdays


                    spacing: 5
                    Repeater {
                        model:ListModel {
                            ListElement {name: "Mo"; flag: 1}
                            ListElement {name: "Di" ; flag: 2}
                            ListElement {name: "Mi"; flag: 4}
                            ListElement {name: "Do"; flag: 8}
                            ListElement {name: "Fr"; flag: 16}
                            ListElement {name: "Sa"; flag: 32}
                            ListElement {name: "So"; flag: 64}
                        }

                        delegate: Column {
                            Label {text:name}
                            CheckBox {width: 20
                                checked: weekFlags & flag
                                onCheckedChanged: {
                                    if (checked) {
                                        form_group.weekFlags = form_group.weekFlags | flag
                                    } else {
                                        form_group.weekFlags = form_group.weekFlags ^ flag
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        Flow {
            id:groupform_clientlist
            anchors.top: groupform_input.bottom
            anchors.topMargin: 20
            width: parent.width
            anchors.bottom: parent.bottom
            Repeater {
                model: _group.personList
                delegate: Item {
                    width: delegate.width
                    height: delegate.height

                    property Person _person
                    property Contract _contract

                    Component.onCompleted: {
                        _person = _group.personList.findById(id);
                        _contract = clientController.loadContract(_person.contracts.at(0));
                    }

                    PersonDelegateSmall {
                        id: delegate
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            _group.personList.remove(id)
                        }
                    }

                    CheckBox {
                        visible: mode == 1
                        checked: Qt.isQtObject(_group)? _person.presence: false
                        onCheckedChanged: {
                            if (Qt.isQtObject(_group)) {
                                _person.presence = checked
                            }
                        }
                    }
                    Text {
                        y: 30
                        text: _contract.openValue
                    }

                }
            }
        }
    }
}


