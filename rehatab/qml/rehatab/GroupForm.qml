import QtQuick 1.1
import QmlFeatures 1.0
import QtDesktop 0.1
import Rehatab 1.0
import "common/FormUtils.js" as FormUtils
import "common"
Rectangle {
    id: form_group

    property PersonGroup _group
    property int mode:0
    property date currentDate;
    property bool formError: false
    signal close()

    function fnSaveGroup() {

        var inputList = new Array(input_name,
                                  input_timeselection)
        var success = true

        for (var i = 0; i < inputList.length; ++i) {
            if (!inputList[i].validate()) {
                success = false
            }
        }

        if (!success) {
            formError = true
            return
        }

        if (!Qt.isQtObject(_group)) {
            _group = groupController.createGroup();
        }
        _group.name = input_name.text
        _group.date = input_timeselection.startDate
        _group.time = input_timeselection.startTime
        _group.minutes = parseInt(input_timeselection.minutes)

        _group.iteration = input_timeselection.iteration()

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

    function fnRemoveGroup() {
        groupController.removeGroup(_group)
        fnCloseDialog()
    }

    function fnLoadGroup() {
        input_name.text = _group.name
        input_timeselection.startDate = _group.date
        input_timeselection.minutes = _group.minutes
        input_timeselection.startTime = _group.time
        var wf
        for (var i=4; i < _group.iteration.length; i++) {
            wf = wf | Math.pow(2, parseInt(_group.iteration.charAt(i))-1)
        }
        input_timeselection.weekFlags = wf

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
                    text: (mode==0)?"Gruppe speichern": "Termin speichern"
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

                Button {
                    text: "Gruppe löschen"
                    onClicked: {
                        focus = true
                        fnRemoveGroup();
                    }
                }
            }
                Text {
                    text: "Überprüfen Sie die rot markierten Eingaben! Detailierte Informationen finden Sie an den Eingaben."
                    color: "red"
                    opacity: formError? 1: 0
                }

                LabelLayout {
                    labelPos: Qt.AlignTop
                    errorRectangle: DefaultErrorRec {}
                    errorMessage: TopErrorMessage {
                        relatedItem: input_name
                    }
                    SimpleFormLabel {
                        text: "Name"
                    }
                    TextField {
                        id: input_name
                        enabled: mode==0
                        font {
                            family: main_style.defaultInputFont.family
                            pixelSize: main_style.defaultInputFont.size
                        }
                        onTextChanged: {
                            if (parent.error) {
                                validate()
                            }
                        }

                        function validate() {
                            var validationRules = new Array(1)
                            validationRules[0]
                                    = FormUtils.fnCreateValidationRule(
                                        input_name.text.length > 0,
                                        qsTr("Der Gruppenname muss eingeben werden!"))


                            return FormUtils.fnProcessValidation(validationRules, parent)

                        }

                        onActiveFocusChanged: {
                            FormUtils.fnShowOrHideErrorMessage(activeFocus || focus, parent)
                        }


                    }
                }

                TimeSelection {
                    id:input_timeselection
                }
            }
            DropArea {
                id: groupform_DropArea
                anchors.top: groupform_input.bottom
                anchors.topMargin: 20
                width: parent.width
                anchors.bottom: parent.bottom
                anchors.fill: parent
                onDragEnter: {
                    parent.color = "yellow"

                }
                onDragLeave: {
                    parent.color = "grey"
                }

                onDrop: {
                    event.accept(Qt.LinkAction);
                    var contractList = clientController.getContracts(event.data.text)
                    var person = clientController.loadPerson(clientController.getPerson(event.data.text))
                    if (Qt.isQtObject(person)) {
                        groupController.addPersonToGroup(person, _group, false)
                    }

                    //comp_contractList.createObject(group_overview, {list: contractList})
                    //fnLinkPersonToGroup(event.data.text, id)
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
                            if (_person.contracts.size() > 0)
                                _contract = clientController.loadContract(_person.contracts.at(0));
                        }

                        PersonDelegateSmall {
                            id: delegate
                        }
                        MouseArea {
                            anchors.fill: parent
                            enabled: mode==0
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
                            anchors.top: delegate.bottom
                            anchors.topMargin: 10
                            anchors.left: delegate.left
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
