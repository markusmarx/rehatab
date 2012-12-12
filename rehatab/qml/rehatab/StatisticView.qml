import QtQuick 1.1
import QmlFeatures 1.0
import QtDesktop 0.1

Item {
    width: 300
    height: 300

    Image {
        id:image
        fillMode: Image.PreserveAspectFit
        anchors.horizontalCenter: parent.horizontalCenter
        source: "content/tooltip.svg"

    }

    Rectangle {
        anchors.top: parent.top
        anchors.topMargin: image.height-1
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        border.color:"grey"
        border.width: 2
        radius: 3
    }

    ListView {
        id:statistic_contract_list
        anchors.fill: parent
        anchors.topMargin: 30
        model: statisticController.getWarningContracts()
        clip: true;

        header: Text {
            text: "Verträge"
        }

        delegate: Rectangle {
            color: "grey"
            width: 200
            height: 50
            Column {
                Row {
            LabelLayout {
                labelPos: Qt.AlignTop
                Label {
                    text: "Startdatum"
                }
                Text {
                    text: Qt.formatDate(validFrom, "dd.MM.yyyy")+ " - "
                }
            }
            LabelLayout {
                labelPos: Qt.AlignTop
                Label {
                    text: "Enddatum"
                }
                Text {
                    text: Qt.formatDate(validTo, "dd.MM.yyyy")
                }
            }

            }
                LabelLayout {
                    labelPos: Qt.AlignTop
                    Label {
                        text: "Offene Sitzungen"
                    }
                    Text {
                        text: openValue
                    }
                }
            }
//                Text {anchors.fill: parent;
//                    text:
//                          + ", " + Qt.formatDate(validTo, "dd.MM.yyyy") + " ("+openValue+")"}

            MouseArea {
                anchors.fill: parent

                onClicked:  {

                }
            }
        }
    }



}
