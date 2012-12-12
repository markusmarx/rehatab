// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import QmlFeatures 1.0

Item {
    width: 246
    height: 50

    property alias name: wName.text
    property alias forename: wForename.text
    property date birth
    property int age

    function fnCopy(item) {
        item.name = name
        item.forename = forename
        item.birth = birth
        item.age = age
    }


//    Image {
//        anchors.top: parent.top
//        anchors.topMargin: 10
//        anchors.left: parent.left
//        anchors.leftMargin: 5

//        id:personImage
//        source: "content/user.png"
//    }

    Column {
        spacing: 2
        anchors {
            top: parent.top
            left: parent.left
            leftMargin: 10
            right: parent.right
            bottom: parent.bottom
            topMargin: 20
        }
        Flow {
            width: parent.width-10
            spacing: 10
            function updateElide() {
                if (wName.pos.y != wForename.pos.y) {
                    wName.width = width-10
                    wForename.width = width-10
                }

            }

            Text {
                id:wName
                color: wForename.color
                font: wForename.font
                elide: Text.ElideRight
                onTextChanged: parent.updateElide()

            }
            Text {
                id:wForename
                font.family: main_style.header1Font.family
                font.pixelSize: main_style.header1Font.size
                font.bold: true
                color: main_style.header1Font.color
                elide: Text.ElideRight
                onTextChanged: parent.updateElide()

            }

        }
        Text {
            text:"*"+Qt.formatDate(birth, "dd.MM.yyyy") + " ("+age+" Jahre)"
            font.family: main_style.header2Font.family
            font.pixelSize: main_style.header2Font.size
            color: main_style.header2Font.color

        }
//        Text {
//            text: "Rezept:" + recept
//            color: "white"
//        }
    }

}
