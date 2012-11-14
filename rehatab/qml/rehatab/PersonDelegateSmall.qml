// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import QmlFeatures 1.0

Item {
    width: 246
    height: 106

    function fnCopy(item) {
        item.name = name
        item.forename = forename
        item.birth = birth
        item.age = age
    }


    Image {
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 5

        id:personImage
        source: "content/user.png"
    }

    Column {
        spacing: 2
        anchors {
            top: parent.top
            left: personImage.right
            leftMargin: 10
            right: parent.right
            bottom: parent.bottom
            topMargin: 20
        }
        Flow {
            width: parent.width-10
            function updateElide() {
                if (wName.pos.y != wForename.pos.y) {
                    wName.width = width-10
                    wForename.width = width-10
                }

            }

            Text {
                id:wName
                text:name + ", "
                color: "black"
                font.family: "Arial"
                font.pointSize: 10
                font.bold: true
                elide: Text.ElideRight
                onTextChanged: parent.updateElide()

            }
            Text {
                id:wForename
                text:forename
                color: "black"
                font.family: "Arial"
                font.pointSize: 10
                font.bold: true
                elide: Text.ElideRight
                onTextChanged: parent.updateElide()

            }

        }
        Text {
            text:"Alter: " + age + " (" + Qt.formatDate(birth, "dd.MM.yyyy") + ")"

            color: "black"
        }
//        Text {
//            text: "Rezept:" + recept
//            color: "white"
//        }
    }

}
