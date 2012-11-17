import QtQuick 1.1
import QtDesktop 0.1
import Rehatab 1.0
import QmlFeatures 1.0
import "common/FormUtils.js" as FormUtils
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


            LabelLayout {
                labelPos: Qt.AlignTop
                labelMargin: 5

                errorRectangle: defaultErrorRec
                errorMessage: topErrorMessage

                SimpleFormLabel {
                    text: "Vertragsende"
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
                                    parseInt(contract_wValidFrom.text.charAt(1)) > 0,
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
                labelPos: Qt.AlignTop
                labelMargin: 5

                errorRectangle: defaultErrorRec
                errorMessage: topErrorMessage

                SimpleFormLabel {
                    text: "Vertragsende"
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
                                    parseInt(contract_wValidTo.text.charAt(1)) > 0,
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
        }

    }
}
