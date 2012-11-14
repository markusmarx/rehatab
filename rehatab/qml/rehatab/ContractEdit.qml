import QtQuick 1.1
import QtDesktop 0.1
import Rehatab 1.0
import QmlFeatures 1.0

Rectangle {
    id:contractEdit
    property Contract contractObj
    property Person personObj

    function fnSaveContract() {

        if (!Qt.isQtObject(contractObj)) {
            contractObj = clientController.createContract();
        }
        contractObj.validFrom = Util.parseDate(contract_wValidFrom.text)
        if (contract_wValidTo.validDate)
            contractObj.validTo = Util.parseDate(contract_wValidTo.text)
        contractObj.value = 50
        contractObj.type = 0
        clientController.saveContract(contractObj, personObj)
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
        Row {
            Button {
                text: "Vertrag anlegen"
                onClicked: fnSaveContract()
            }
        }

        LabelLayout {
            labelPos: Qt.AlignTop
            Label {
                text: "Von"
            }

            DateEdit {
                id: contract_wValidFrom

            }
        }
        LabelLayout {
            labelPos: Qt.AlignTop
            Label {
                text: "bis"
            }

            DateEdit {
                id: contract_wValidTo
            }
        }
    }
    }

}
