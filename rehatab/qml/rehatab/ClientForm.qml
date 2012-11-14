import QtQuick 1.1
import QtDesktop 0.1
import QmlFeatures 1.0
import "common/FormUtils.js" as FormUtils
Item {
    id: client_form
    property int formLabelPos: Qt.AlignTop

    property bool formError: false

    signal close()

    onClose: {
        client_form.destroy()
    }

    onActiveFocusChanged: {
        if (activeFocus || focus)
            input_forename.forceActiveFocus()
    }

    function fnSaveClient() {

        var inputList = new Array(input_forename, input_surname, input_birth,
                                  input_sex)
        var success = true

        for (var i = 0; i < inputList.length; ++i) {
            if (!inputList[i].validate()) {
                success = false
            }
        }

        if (success) {
            var personObj = clientController.createPerson();
                personObj.name = input_surname.text
                personObj.forename = input_forename.text
                personObj.birth = input_birth.date;
                clientController.savePerson(personObj)
                close()
        } else {
            formError = true
        }


    }


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
                    onClicked: client_form.close()
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
                    errorRectangle: defaultErrorRec
                    errorMessage: topErrorMessage

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

                    errorRectangle: defaultErrorRec
                    errorMessage: topErrorMessage

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

                    errorRectangle: defaultErrorRec
                    errorMessage: topErrorMessage

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
                                        parseInt(input_birth.text.charAt(1)) > 0,
                                            qsTr("Ein Datum eingeben!"))
                            validationRules[1]
                                    = FormUtils.fnCreateValidationRule(
                                        true,
                                        qsTr("Ein gültiges Datum eingeben! Bsp: 12.10.2012"))

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

                    errorRectangle: sexErrorRec
                    errorMessage: topErrorMessage

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
                                if (checked)
                                    input_male.checked = false
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
                                if (checked)
                                    input_female.checked = false
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

    Component {
        id: sexErrorRec
        Rectangle {
            border.color: "#FF7777"
            color: "#FF7777"
            border.width: 2
            x: -5
            z: -1

            Behavior on opacity {
                NumberAnimation { duration: 500}
            }
        }
    }

    Component {
        id: defaultErrorRec
        Rectangle {
            border.color: "#cc0000"
            color: "transparent"
            border.width: 2

            Behavior on opacity {
                NumberAnimation {duration: 500}
            }
        }
    }

    Component {
        id: defaultErrorMessage
        ToolTip {
            width: text.width+20
            height: text.height+15
            property alias message: text.text
            Text {
                id:text
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                color: "white"
            }

            Behavior on opacity {
                NumberAnimation { duration:500}
            }
        }
    }

    Component {
        id: topErrorMessage
        ToolTip {
            width: text.width+20
            height: text.height+15
            anchor: Qt.AlignTop
            property alias message: text.text
            Text {
                id:text
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                color: "white"
            }

            Behavior on opacity {
                NumberAnimation { duration:500}
            }
        }
    }

}
