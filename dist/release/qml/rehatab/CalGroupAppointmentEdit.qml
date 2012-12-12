import QtQuick 1.1
import QtDesktop 0.1
import Rehatab 1.0
import QmlFeatures 1.0

Rectangle {
    id: calGroupAppointmentEdit

    property PersonGroup _group
    property date currentDate;

    signal close()

    function fnCloseDialog() {
        close();
    }


    function fnSetFields() {
        label_name.text = _group.name
    }

    function fnSaveGroup() {
        groupController.saveGroup(_group, currentDate)
        fnCloseDialog()
    }

    FocusScope {
        anchors.fill: parent

        Column {
            id: input_calgroup
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                leftMargin: 10
            }
            spacing: 10

            Row {

                Button {
                    text: "Termin speichern"
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

                SimpleFormLabel {
                    text: "Name"
                }
                Text {
                    id: label_name
                    font {
                        family: main_style.defaultInputFont.family
                        pixelSize: main_style.defaultInputFont.size
                    }
                }
            }
        }
        Flow {
            id:calgroup_clientlist
            anchors {
                top:input_calgroup.bottom
                topMargin: 20
                leftMargin: 10
            }
            width: parent.width
            anchors.bottom: parent.bottom
            Repeater {
                model: _group.personList
                delegate: Item {
                    width: person_delegate.width
                    height: person_delegate.height

                    property Person _person
                    property Contract _contract

                    Component.onCompleted: {
                        _person = _group.personList.findById(id);
                        if (_person.contracts.size() > 0)
                            _contract = clientController.loadContract(_person.contracts.at(0));

                        person_delegate.name = name
                        person_delegate.forename = forename
                        person_delegate.birth = birth
                        person_delegate.age = age
                    }

                    PersonDelegateSmall {
                        id: person_delegate
                    }


                    CheckBox {
                        checked: Qt.isQtObject(_group)? _person.presence: false
                        onCheckedChanged: {
                            if (Qt.isQtObject(_group)) {
                                _person.presence = checked
                                if (!Qt.isQtObject(_contract)) return;
                                if (checked) {
                                    _contract.openValue -= 1
                                } else {
                                    _contract.openValue += 1
                                }
                            }
                        }
                    }
                    Text {
                        anchors.top: person_delegate.bottom
                        anchors.topMargin: 10
                        anchors.left: person_delegate.left
                        anchors.leftMargin: 10
                        text: Qt.isQtObject(_contract)?_contract.openValue + " offene Sitzungen":""
                        font.family: main_style.header2Font.family
                        font.pixelSize: main_style.header2Font.size
                        color: main_style.header2Font.color
                    }

                }
            }
        }

    }
}
