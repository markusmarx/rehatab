import QtQuick 1.1
import QtDesktop 0.1

Item {

    property Item _currentView
    property int _lastSelectedClientId:-1
    function fnShowNewClientForm() {

        if (_currentView) {
            lst_view.fnClearSelection()
            _currentView.destroy()
        }

        _currentView = comp_clientform.createObject(main_content);
        _currentView.forceActiveFocus()
    }

    function fnOpenCloseClientOverView(open) {
        console.log("open person " + _lastSelectedClientId)
        if (open) {

            if (_currentView)
                _currentView.destroy()

            if (_lastSelectedClientId >= 0) {
                _currentView = comp_clientview.createObject(pag_contentarea, {opacity:0,
                                                                _person: clientController.loadPerson(clientController.getPerson(_lastSelectedClientId))
                                                                    } )
                //_currentView.fnLoadClient(_lastSelectedClientId);
                _currentView.forceActiveFocus()
                _currentView.opacity = 1

            }

            lst_view.visible = true
        } else {
            _currentView.destroy()

        }

    }


    function fnSwitchToClientView(open) {
        if (open) {
            fnOpenCloseClientOverView(true)
        }
    }


    Component.onCompleted: {

        stateMaschine.openPersonState.isActiveChanged.connect(fnOpenCloseClientOverView)

    }


    Component {
        id: comp_clientform
        ClientForm {
            anchors.fill: parent
        }
    }

    Component {
        id: comp_clientview
        ClientOverView {
            anchors.fill: parent
        }
    }





    Component {
        id: comp_contractedit
        ContractEdit {
            anchors.fill: parent
        }
    }

    Component {
        id: comp_clientappointmentedit
        ClientAppointmentEdit {
            anchors.fill: parent
        }
    }


    Item {
        id: pag_navigation
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: 246

        Button {
            id: btn_newclient
            anchors.top: parent.top
            text: "Neuer Klient"
            onClicked: fnShowNewClientForm()
        }

//        TextField {
//            id:input_clientsearch
//            anchors.top: btn_newclient.bottom
//            anchors.topMargin: 5

//            width: parent.width-10

//        }

        ClientListView {
            id: lst_view
            anchors.top: btn_newclient.bottom
            anchors.topMargin: 5
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
        }

    }

    Item {
        id: pag_contentarea
        anchors.top:parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        anchors.left: pag_navigation.right
        anchors.rightMargin: 5

    }



}
