.pragma library

function fnCreateValidationRule(result, message) {
    
    var validationRule = Object()
    validationRule["msg"] = message
    validationRule["result"] = result
    return validationRule
}

function fnProcessValidation(validationRules, form) {
    var errorMsg;
    var success = true;
    for (var i = 0; i < validationRules.length; i++) {

        if (!validationRules[i]["result"]) {
            errorMsg = validationRules[i]["msg"]
            success = false
            break;
        }

    }

    if (!success) {
        form.errorMsg = errorMsg
        form.error = true
    } else {
        form.error = false
        form.fnHideErrorMessage()
    }
    return success;
}

function fnShowOrHideErrorMessage(focus, form) {
    if (focus && form.error) {
        form.fnShowErrorMessage(form.errorMsg)
    } else if (!focus) {
        form.fnHideErrorMessage();
    }
}

function fnValidateForm(inputList) {
    var success = true

    for (var i = 0; i < inputList.length; ++i) {
        if (!inputList[i].validate()) {
            success = false
        }
    }
    return success;
}
