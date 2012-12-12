// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import QtDesktop 0.1
import Rehatab 1.0
Item {
    id:selector
    property Person person
    property Item popup
    property Item popupParent
    property variant model
    property Component delegate
    property int currentIdx
    property Item selectedDelegate

    signal chooseItem()

    Component.onCompleted: {
        //selectedDelegate.parent = selected_item;

    }

    //height: delegate.height

    /*Item {
        id:selected_item

    }*/


    ListView {
        id: selector_list
        anchors.fill: parent
        model: parent.model
        delegate: parent.delegate
        visible:true
    }

}
