import QtQuick 2.0
import QtQuick.Controls 2.12
Item {
    id: root
    property var lwidth: mainwindow.width
    property alias model: __lview.model
    property alias delegate: __lview.delegate
    property alias count: __lview.count
    ListView {
        id: __lview
        width: parent.width
        height: parent.height
        remove: Transition {
            NumberAnimation {
                property: "x"
                to: -100
                duration: 100
            }
        }
        displaced: Transition {
            NumberAnimation {
                property: "y"
                duration: 200
            }
        }
    }
}


