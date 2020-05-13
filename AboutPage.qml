import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Page {
    width: mainwindow.width
    height: mainwindow.height
    header: MyToolBar {
        text.text: "About"
        button.onClicked: stackview.pop()
        button.text: "\u2190"
    }
    Rectangle {
        width: parent.width
        height: parent.height
        color: "#57655c"
    }
    ColumnLayout {
        width: parent.width
        spacing: 0
        ItemDelegate {
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: 70
            Item {
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.top: parent.top
                anchors.topMargin: 10
                Text {
                    id: versiontitle
                    text: "Version"
                    font.bold: Font.DemiBold
                    font.pixelSize: 15
                }
                Text {
                    anchors.top: versiontitle.bottom
                    anchors.topMargin: 5
                    text: "0.5.0-beta"
                }
            }

            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 7
                color: "#959595"
                opacity: 0.5
            }
        }

        ItemDelegate {
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: 240
            Item {
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.top: parent.top
                anchors.topMargin: 10
                Text {
                    id: abouttitle
                    text: "About"
                    font.bold: Font.DemiBold
                    font.pixelSize: 15
                }
                Text {
                    anchors.top: abouttitle.bottom
                    anchors.topMargin: 5
                    text: "<b>Avid Group</b><br>This is a friendship-based group<br><br><b>Code On Github:</b><br>
<a href='https://Github.com'>https://github.com</a><br><br><b>Contact us:</b><br>Vida Azadi: azadivida@gmail.com<br>SeedPuller: SeedPuller@gmail.com"
                    wrapMode: Text.WordWrap
                }
            }

            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 7
                color: "#959595"
                opacity: 0.5
            }
        }
    }
}
