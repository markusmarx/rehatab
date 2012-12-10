import QtQuick 1.1
import QtDesktop 0.1
import Rehatab 1.0
import QmlFeatures 1.0
import "common/FormUtils.js" as FormUtils
import "common"
Rectangle {
    id:contractEdit
    property Contract contractObj
    property Person personObj
    property bool formError: false

    function fnSaveContract() {

        var inputList = new Array(contract_wValidFrom, contract_wValidTo)
        var success = true

        for (var i = 0; i < inputList.length; ++i) {
            if (!inputList[i].validate()) {
                success = false
            }
        }

        if (success) {
            if (!Qt.isQtObject(contractObj)) {
                contractObj = clientController.createContract();
            }
            contractObj.validFrom = Util.parseDate(contract_wValidFrom.text)
            if (contract_wValidTo.validDate)
                contractObj.validTo = Util.parseDate(contract_wValidTo.text)
            contractObj.value = 50
            contractObj.type = 0
            clientController.saveContract(contractObj, personObj)
            fnCloseContractForm()
        } else {
            formError = true
        }

    }

    function fnCloseContractForm() {
        contractEdit.destroy()
    }

    function loadItem(contract) {
        contractObj = contract

    }

    function newItem(contract) {
        contractObj = contract;
    }



    FocusScope {
        Column {
            anchors.fill: parent
            spacing: 10
            Row {
                Button {
                    text: "Vertrag anlegen"
                    onClicked: {
                        focus = true
                        fnSaveContract()
                    }
                }
                Button {
                    text: "Abbrechen"
                    onClicked: {
                        focus = true
                        fnCloseContractForm()
                    }
                }
            }
            Text {
                text: "Überprüfen Sie die rot markierten Eingaben! Detailierte Informationen finden Sie an den Eingaben."
                color: "red"
                opacity: formError? 1: 0
            }


            Row {
                Column {
                    LabelLayout {
                        labelPos: Qt.AlignRight
                        labelMargin: 5

                        errorRectangle: DefaultErrorRec {}
                        errorMessage: TopErrorMessage {
                            relatedItem: input_reha
                        }
                        Text {
                            text: "<b>Rehabilitationssport</b>\ngemäß §43 Abs.1 Satz 1 SGB V"

                        }

                        CheckBox {
                            id: input_reha
                            width: 25
                        }

                    }
                    Text {
                        text: "für"

                    }
                    LabelLayout {
                        labelPos: Qt.AlignRight
                        labelMargin: 5

                        errorRectangle: DefaultErrorRec {}
                        errorMessage: TopErrorMessage {
                            relatedItem: input_reha
                        }
                        Text {
                            text: "50 Übungseinheiten"

                        }
                        CheckBox {
                            id: input_fifty
                            width: 25
                        }
                    }
                    LabelLayout {
                        labelPos: Qt.AlignRight
                        labelMargin: 5

                        errorRectangle: DefaultErrorRec {}
                        errorMessage: TopErrorMessage {
                            relatedItem: input_reha
                        }
                        Text {
                            text: "120 Übungseinheiten"

                        }
                        CheckBox {
                            id: input_onehundert
                            width: 25
                        }
                    }
                }


                Column {

                }
            }


            Row {
                LabelLayout {
                    labelPos: Qt.AlignLeft
                    labelMargin: 5

                    errorRectangle: DefaultErrorRec {}
                    errorMessage: TopErrorMessage {
                        relatedItem: contract_wValidFrom
                    }
                    SimpleFormLabel {
                        text: "Für den Zeitraum vom"
                    }

                    DateEdit {
                        id: contract_wValidFrom
                        textColor:  main_style.defaultInputFont.color
                        inputMask: "99.99.9999"
                        fieldWidth: 150
                        font.family: main_style.defaultInputFont.family
                        font.pixelSize: main_style.defaultInputFont.size
                        KeyNavigation.tab: contract_wValidTo

                        function validate() {

                            var validationRules = new Array(1)
                            validationRules[0]
                                    = FormUtils.fnCreateValidationRule(
                                        parseInt(contract_wValidFrom.text.charAt(0)) >= 0,
                                        qsTr("Ein Datum eingeben!"))
                            validationRules[1]
                                    = FormUtils.fnCreateValidationRule(
                                        contract_wValidFrom.validDate,
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
                    labelPos: Qt.AlignLeft
                    labelMargin: 5

                    errorRectangle: DefaultErrorRec {}
                    errorMessage: TopErrorMessage {
                        relatedItem: contract_wValidTo
                    }

                    SimpleFormLabel {
                        text: "längstens bis"
                    }

                    DateEdit {
                        id: contract_wValidTo
                        textColor:  main_style.defaultInputFont.color
                        inputMask: "99.99.9999"
                        fieldWidth: 150
                        font.family: main_style.defaultInputFont.family
                        font.pixelSize: main_style.defaultInputFont.size
                        KeyNavigation.tab: contract_wValidFrom

                        function validate() {

                            var validationRules = new Array(1)
                            validationRules[0]
                                    = FormUtils.fnCreateValidationRule(
                                        parseInt(contract_wValidTo.text.charAt(0)) >= 0,
                                        qsTr("Ein Datum eingeben!"))
                            validationRules[1]
                                    = FormUtils.fnCreateValidationRule(
                                        contract_wValidTo.validDate,
                                        qsTr("Ein gültiges Datum eingeben! Bsp: 12.10.2012"))

                            validationRules[2]
                                    = FormUtils.fnCreateValidationRule(
                                        contract_wValidTo.date > contract_wValidFrom.date ,
                                        qsTr("Das Ablaufdatum muss nach dem Startdatum kommen!"))

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
            }

        }
    }
}
