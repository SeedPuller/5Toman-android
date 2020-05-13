import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

ToolBar {
    width: parent.width
    height: 50
    property alias button: __toolbtn
    property alias text: __text
    RowLayout {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 5
        ToolButton {
            id: __toolbtn
            text: "‫‪\u2630"
            font.pixelSize: 40
            contentItem: Text{
                text: __toolbtn.text
                font: __toolbtn.font
                color: "#cfcfcf"
                leftPadding: 5
            }
        }
        Text {
            id: __text
            text: "5Toman"
            color: "#cfcfcf"
            font.pixelSize: 20
        }
    }
}
