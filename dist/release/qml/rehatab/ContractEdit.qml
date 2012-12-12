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
    property int _value: -1

    function fnSaveContract() {

        var inputList = new Array(input_fifty, input_120, input_manual, contract_wValidFrom, contract_wValidTo)
        var success = true

        if (input_fifty.checked) _value = 50
        if (input_120.checked) _value = 120
        if (input_manual.text != "") _value = parseInt(input_manual.text)

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
            contractObj.value = _value
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

    function fnRehaVlidate(itemParent) {

        var validationRules = new Array(1)
        validationRules[0]
                = FormUtils.fnCreateValidationRule(
                    _value > 0,
                    qsTr("Eine Übungseinheit wählen!"))

        return FormUtils.fnProcessValidation(validationRules, itemParent)
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
                    spacing: 10
                    LabelLayout {
                        labelPos: Qt.AlignRight
                        labelMargin: 5

                        errorRectangle: DefaultErrorRec {}
                        errorMessage: TopErrorMessage {
                            relatedItem: input_reha
                        }
                        Text {
                            text: "<b>Rehabilitationssport</b> gemäß §43 Abs.1 Satz 1 SGB V i.V. m. § 44 Abs. 1 Nr. 3 SGB IX"

                        }

                        CheckBox {
                            id: input_reha
                            width: 25
                            enabled: false
                            checked: true
                        }

                    }
                    Text {
                        text: "für"

                    }
                    LabelLayout {
                        labelPos: Qt.AlignRight
                        labelMargin: 5

                        errorRectangle: SexErrorRec {}
                        errorMessage: TopErrorMessage {
                            relatedItem: input_fifty
                        }


                        Text {
                            text: "50 Übungseinheiten / 18 Monate"

                        }
                        CheckBox {
                            id: input_fifty
                            width: 25

                            function validate() {
                                return fnRehaVlidate(parent)
                            }
                        }
                    }
                    LabelLayout {
                        labelPos: Qt.AlignRight
                        labelMargin: 5

                        errorRectangle: SexErrorRec {}
                        errorMessage: TopErrorMessage {
                            relatedItem: input_reha
                        }
                        Text {
                            text: "120 Übungseinheiten / 36 Monate"

                        }
                        CheckBox {
                            id: input_120
                            width: 25
                            function validate() {
                                return fnRehaVlidate(parent)
                            }
                        }
                    }

                    LabelLayout {
                        labelPos: Qt.AlignRight
                        labelMargin: 5
                        itemMargin: 5
                        errorRectangle: DefaultErrorRec {}
                        errorMessage: TopErrorMessage {
                            relatedItem: input_reha
                        }
                        Text {
                            text: "Übungseinheiten"

                        }
                        TextField {
                            id: input_manual
                            width: 50
                            function validate() {
                                return fnRehaVlidate(parent)
                            }
                        }
                    }

                }


                Column {

                }
            }


            Row {
                spacing: 5
                LabelLayout {
                    labelPos: Qt.AlignTop
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
                    labelPos: Qt.AlignTop
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
