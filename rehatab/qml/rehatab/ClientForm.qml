import QtQuick 1.1
import QtDesktop 0.1
import QmlFeatures 1.0
import Rehatab 1.0
import "common/FormUtils.js" as FormUtils
import "common"
Rectangle {
    id: client_form
    property int formLabelPos: Qt.AlignTop
    property bool formError: false
    property Person personObj

    signal close()

    onClose: {
        client_form.destroy()
    }

    onActiveFocusChanged: {
        if (activeFocus || focus)
            input_forename.forceActiveFocus()
    }

    Component.onCompleted: {

        if (Qt.isQtObject(personObj)) {
            fnLoadPerson()
        }

    }

    function fnSaveClient() {

        var inputList = new Array(input_forename, input_surname, input_birth,
                                  input_sex)

        if (FormUtils.fnValidateForm(inputList)) {
            if (!Qt.isQtObject(personObj))
                personObj = clientController.createPerson();
            personObj.name = input_surname.text
            personObj.forename = input_forename.text
            personObj.birth = input_birth.date;
            personObj.sex = input_sex.sex
            clientController.savePerson(personObj)
            close()
        } else {
            formError = true
        }


    }

    function fnLoadPerson() {
        input_forename.text = personObj.forename
        input_surname.text = personObj.name
        input_birth.date = personObj.birth
        input_sex.sex = personObj.sex
    }

    color: "white"

    FocusScope {
        Column {
            anchors.fill: parent

            anchors.leftMargin: 20
            spacing: 10
            Row {
                Button {
                    text: "Neuen Klient speichern"
                    onClicked: {
                        focus = true
                        fnSaveClient()
                    }
                }
                Button {
                    text: "Abbrechen"
                    onClicked: {
                        focus = true
                        client_form.close()
                    }
                }
            }

            Text {
                text: "Überprüfen Sie die rot markierten Eingaben! Detailierte Informationen finden Sie an den Eingaben."
                color: "red"
                opacity: formError? 1: 0
            }

            Text {
                text: qsTr("Allgemeine Informationen zur Person")
                font {
                    family: "Arial"
                    pixelSize: 16
                }
            }
            Row {
                spacing: 10
                LabelLayout {
                    id:lbl
                    labelPos: formLabelPos
                    labelMargin: 5
                    errorRectangle: DefaultErrorRec {}
                    errorMessage: TopErrorMessage {
                        relatedItem: input_forename
                    }

                    SimpleFormLabel {
                        text: "Vorname"
                    }

                    TextField {
                        id: input_forename
                        textColor: main_style.defaultInputFont.color
                        width: 250

                        font {
                            family: main_style.defaultInputFont.family
                            pixelSize: main_style.defaultInputFont.size
                        }

                        function validate() {
                            var validationRules = new Array(1)
                            validationRules[0]
                                    = FormUtils.fnCreateValidationRule(
                                        input_forename.text.length > 0,
                                            qsTr("Der Vorname muss eingeben werden!"))


                            return FormUtils.fnProcessValidation(validationRules, parent)
                        }

                        KeyNavigation.tab: input_surname

                        onTextChanged: {
                            if (parent.error) {
                                validate()
                            }
                        }
                        onActiveFocusChanged: {
                            FormUtils.fnShowOrHideErrorMessage(activeFocus || focus, parent)
                        }


                    }

                }

                LabelLayout {
                    labelPos: formLabelPos
                    labelMargin: 5

                    errorRectangle: DefaultErrorRec {}
                    errorMessage: TopErrorMessage {
                                      relatedItem: input_surname
                                  }

                    SimpleFormLabel {
                        text: "Nachname"
                    }

                    TextField {
                        id: input_surname
                        textColor: input_forename.textColor
                        width: 250
                        font: input_forename.font
                        KeyNavigation.tab: input_birth
                        onTextChanged: {
                            if (parent.error) {
                                validate()
                            }
                        }

                        function validate() {
                            var validationRules = new Array(1)
                            validationRules[0]
                                    = FormUtils.fnCreateValidationRule(
                                        input_surname.text.length > 0,
                                            qsTr("Der Nachname muss eingeben werden!"))


                            return FormUtils.fnProcessValidation(validationRules, parent)

                        }

                        onActiveFocusChanged: {
                            FormUtils.fnShowOrHideErrorMessage(activeFocus || focus, parent)
                        }

                    }

                }
            }

            Row {
                spacing: 40
                LabelLayout {
                    labelPos: formLabelPos
                    labelMargin: 5

                    errorRectangle: DefaultErrorRec {}
                    errorMessage: TopErrorMessage {
                                  relatedItem: input_birth
                              }

                    SimpleFormLabel {
                        text: "Geboren am"
                    }

                    DateEdit {
                        id: input_birth
                        textColor: input_forename.textColor
                        inputMask: "99.99.9999"
                        fieldWidth: 150
                        font:input_forename.font
                        KeyNavigation.tab: input_female



                        function validate() {

                            var validationRules = new Array(1)
                            validationRules[0]
                                    = FormUtils.fnCreateValidationRule(
                                        parseInt(input_birth.text.charAt(0)) >= 0,
                                            qsTr("Ein Datum eingeben!"))
                            validationRules[1]
                                    = FormUtils.fnCreateValidationRule(
                                        input_birth.validDate,
                                        qsTr("Ein gültiges Datum eingeben! Bsp: 12.10.2012"))

                            validationRules[2]
                                    = FormUtils.fnCreateValidationRule(
                                        input_birth.date < new Date(Date.now()),
                                        qsTr("Ein Geburtstagsdatum muss in der Vergangenheit liegen!"))

                            return FormUtils.fnProcessValidation(validationRules, parent)
                        }

                        onActiveFocusChanged: {
                            FormUtils.fnShowOrHideErrorMessage(activeFocus || focus, parent)
                        }

                        onTextChanged: {
                            if (parent && parent.error) {
                                validate()
                            }
                        }

                    }

                }

                LabelLayout {
                    labelPos: formLabelPos
                    labelMargin: 0

                    errorRectangle: SexErrorRec {}
                    errorMessage: TopErrorMessage {
                                      relatedItem: input_sex
                                  }

                    Label {
                        text: "Geschlecht"
                        color: "#585858"
                        font {
                            family: "Arial"
                            pixelSize: 12
                            bold:true
                        }
                    }

                    Row {
                        id:input_sex
                        property int sex

                        onSexChanged: {
                            if (sex == 1) {
                                input_female.checked = true;
                            } else if (sex == 2){
                                input_male.checked = true;
                            }
                        }

                        function validate() {

                            var validationRules = new Array(1)
                            validationRules[0]
                                    = FormUtils.fnCreateValidationRule(
                                        input_male.checked || input_female.checked,
                                            qsTr("Das Geschlecht wählen!"))

                            return FormUtils.fnProcessValidation(validationRules, parent)
                        }
                        CheckBox {
                            id:input_female
                            text: "W"
                            width: 50
                            height: input_birth.height-1

                            onCheckedChanged: {
                                if (checked) {
                                    input_male.checked = false
                                    parent.sex = 1;
                                }
                                if (parent.parent.error)
                                    parent.validate()

                            }
                            onClicked: {
                                focus = true
                            }
                            onContainsMouseChanged:
                                FormUtils.fnShowOrHideErrorMessage(containsMouse, parent.parent)

                            KeyNavigation.tab: input_male
                        }
                        CheckBox {
                            id:input_male
                            text: "M"
                            width: 50
                            height: input_birth.height-1
                            onContainsMouseChanged:
                                FormUtils.fnShowOrHideErrorMessage(containsMouse, parent.parent)
                            onCheckedChanged: {
                                if (checked) {
                                    input_female.checked = false
                                    parent.sex = 2;
                                }
                                if (parent.parent.error)
                                    parent.validate()
                            }

                            onClicked: {
                                focus = true
                            }
                        }
                    }
                }
            }
        }
    }

}
