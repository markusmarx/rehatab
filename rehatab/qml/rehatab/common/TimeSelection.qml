import QtQuick 1.1
import QmlFeatures 1.0
import QtDesktop 0.1
import Rehatab 1.0
import "FormUtils.js" as FormUtils
import ".."

Column {
    id: timeselection
    property alias startDate: input_startDate.date
    property alias startTime: input_starttime.time
    property alias minutes: input_minutes.text
    property int weekFlags
    function validate() {

        var inputList = new Array(input_startDate,
                                  input_starttime,
                                  input_minutes,
                                  input_weekdays)
        var success = true

        for (var i = 0; i < inputList.length; ++i) {
            if (!inputList[i].validate()) {
                success = false
            }
        }

        return success;

    }

    function iteration() {
        var iteration = "w 1 "
        for (var i = 1, k = 1; k <= 7; i=i*2,k++) {
            if (timeselection.weekFlags & i) {
                iteration += k.toString()
            }
        }
        return iteration;
    }

    LabelLayout {
        labelPos: Qt.AlignTop
        errorRectangle: DefaultErrorRec {}
        errorMessage: TopErrorMessage {
            relatedItem: input_startDate
        }
        SimpleFormLabel {
            text: "Started am"
        }
        
        
        DateEdit {
            id:input_startDate
            enabled: timeselection.enabled
            inputMask: "99.99.9999"
            fieldWidth: 150
            font {
                family: main_style.defaultInputFont.family
                pixelSize: main_style.defaultInputFont.size
            }
            function validate() {
                
                var validationRules = new Array(1)
                validationRules[0]
                        = FormUtils.fnCreateValidationRule(
                            parseInt(input_startDate.text.charAt(0)) >= 0,
                            qsTr("Ein Datum eingeben!"))
                validationRules[1]
                        = FormUtils.fnCreateValidationRule(
                            input_startDate.validDate,
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
    
    Row {
        LabelLayout {
            labelPos: Qt.AlignTop
            
            errorRectangle: DefaultErrorRec {}
            errorMessage: TopErrorMessage {
                relatedItem: input_starttime
            }
            SimpleFormLabel {
                text: "um (hh:mm)"
            }
            
            TimeEdit {
                id:input_starttime
                enabled: timeselection.enabled
                font: input_startDate.font
                
                onTextChanged: {
                    if (parent.error) {
                        validate()
                    }
                }
                
                function validate() {
                    var validationRules = new Array(1)
                    validationRules[0]
                            = FormUtils.fnCreateValidationRule(
                                input_starttime.validTime,
                                qsTr("Eine Zeit eingeben Bsp: 08:00!"))
                    
                    
                    return FormUtils.fnProcessValidation(validationRules, parent)
                    
                }
                
                
                onActiveFocusChanged: {
                    FormUtils.fnShowOrHideErrorMessage(activeFocus || focus, parent)
                }
                
            }
        }
        LabelLayout {
            labelPos: Qt.AlignTop
            errorRectangle: DefaultErrorRec {}
            errorMessage: TopErrorMessage {
                relatedItem: input_minutes
            }
            SimpleFormLabel {
                text: "Dauer in Minuten"
            }
            
            TextField {
                id:input_minutes
                validator: IntValidator {}
                enabled: timeselection.enabled
                font: input_startDate.font
                onTextChanged: {
                    if (parent.error) {
                        validate()
                    }
                }
                
                function validate() {
                    var validationRules = new Array(1)
                    validationRules[0]
                            = FormUtils.fnCreateValidationRule(
                                input_minutes.acceptableInput,
                                qsTr("Die Minuten angeben Bsp: 45"))
                    
                    
                    return FormUtils.fnProcessValidation(validationRules, parent)
                    
                }
                
                onActiveFocusChanged: {
                    FormUtils.fnShowOrHideErrorMessage(activeFocus || focus, parent)
                }
                
            }
        }
    }
    
    LabelLayout {
        labelPos: Qt.AlignTop
        itemMargin: 10
        errorRectangle: SexErrorRec {}
        errorMessage: TopErrorMessage {
            relatedItem: input_weekdays
            deltaY: -25
        }
        
        SimpleFormLabel { text: "Wiederholung jede\nWoche am"}
        
        Row {
            id: input_weekdays
            
            function validate() {
                
                var validationRules = new Array(1)
                validationRules[0]
                        = FormUtils.fnCreateValidationRule(
                            timeselection.weekFlags > 0,
                            qsTr("Mindestens einen Tag auswählen!"))
                
                return FormUtils.fnProcessValidation(validationRules, parent)
            }
            
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
                
                delegate:
                    Item {
                    width: childrenRect.width
                    height: childrenRect.height
                    
                    
                    Column {
                        Label {text:name}
                        CheckBox {width: 20
                            checked: weekFlags & flag
                            enabled: timeselection.enabled
                            onCheckedChanged: {
                                if (checked) {
                                    timeselection.weekFlags = timeselection.weekFlags | flag
                                } else {
                                    timeselection.weekFlags = timeselection.weekFlags ^ flag
                                }
                            }
                            
                            onContainsMouseChanged:
                                FormUtils.fnShowOrHideErrorMessage(containsMouse, input_weekdays.parent)
                            
                        }
                        
                    }
                    
                }
            }
        }
        
    }
}
