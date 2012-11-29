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

        _currentView = comp_clientform.createObject(pag_contentarea);
        _currentView.forceActiveFocus()
    }

    function fnOpenCloseClientOverView(open) {
        console.log("open person " + _lastSelectedClientId)
        if (open) {

            if (_currentView)
                _currentView.destroy()

            if (_lastSelectedClientId >= 0) {
                _currentView = comp_clientoverview.createObject(pag_contentarea, {opacity:0,
                                                                _person: clientController.loadPerson(clientController.getPerson(_lastSelectedClientId))
                                                                    } )
                //_currentView.fnLoadClient(_lastSelectedClientId);
                _currentView.forceActiveFocus()
                _currentView.opacity = 1
            }


        } else {
            _currentView.destroy()

        }

    }

    function fnOpenCloseGroupView(open) {
        if (open) {
            if (_currentView)
                _currentView.destroy()

            _currentView = comp_groupoverview.createObject(pag_contentarea)
        }
    }

    function fnSwitchToClientView(open) {
        if (open) {
            fnOpenCloseClientOverView(true)
        }
    }

    function fnOpenGroupForm(groupId) {
        if (_currentView) {
            _currentView.destroy();
        }

        _currentView = comp_groupform.createObject(pag_contentarea, {_group: groupController.loadGroup(groupController.getGroup(groupId))})
        _currentView.fnLoadGroup()
    }

    function fnNewGroup() {
        if (_currentView) {
            _currentView.destroy();
        }
        _currentView = comp_groupform.createObject(pag_contentarea)
    }


    Component.onCompleted: {
        stateMaschine.groupMenuState.isActiveChanged.connect(fnOpenCloseGroupView)
        stateMaschine.openPersonState.isActiveChanged.connect(fnOpenCloseClientOverView)
        stateMaschine.personMenuState.isActiveChanged.connect(fnSwitchToClientView)
    }


    Component {
        id: comp_clientform
        ClientForm {
            anchors.fill: parent
        }
    }

    Component {
        id: comp_clientoverview
        ClientOverView {
            anchors.fill: parent
        }
    }

    Component {
        id: comp_groupoverview
        GroupOverView {
            anchors.fill: parent
        }
    }

    Component {
        id:comp_groupform
        GroupForm {
            anchors.fill: parent
            onClose: {
                fnOpenCloseGroupView(true)
            }
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
