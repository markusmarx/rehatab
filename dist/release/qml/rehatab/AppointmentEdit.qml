import QtQuick 1.1
import QtDesktop 0.1
import Rehatab 1.0
import "common" as Common
Item {
    property ClientAppointmentSummary appSumObj

    function saveItem() {
        if (appSumObj != null) {
            appSumObj.validFrom = personController.toQDate(wValidFrom.text)
            appSumObj.validTo = personController.toQDate(wValidTo.text)
        }
    }

    function loadItem(appSum) {
        appSumObj = appSum
        wValidFrom.text = Util.formatDate(appSumObj.validFrom)
        wValidTo.text = Util.formatDate(appSumObj.validTo)
    }

    function newItem(appSum) {
        appSumObj = appSum;
        wValidFrom.text = Util.formatDate(appSumObj.validFrom)
        wValidTo.text = Util.formatDate(appSumObj.validTo)
    }

    Common.Selector {
        id: col_app_contract
        anchors {
            top: parent.top

        }

        model: personObj.contracts
        delegate: Text {
            text: validFrom + " - " + validTo
        }
    }

//    Column {
//        id: col_app_detail
//        anchors.fill: parent

//        TextField {
//            id: wValidFrom

//        }
//        TextField {
//            id: wValidTo

//        }
//    }




}
