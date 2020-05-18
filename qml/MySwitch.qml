import QtQuick 2.0

Item {
    id: root
    width: 100
    height: 30
    property bool choosed: false
    state: choosed ? "choosed" : "not-choosed"

    states: [
        State {
            name: "choosed"
            PropertyChanges { target: __indicator; x: __background.width - __indicator.width }
        },
        State {
            name: "not-choosed"
            PropertyChanges { target: __indicator; x: 0 }
        }
    ]
    transitions: [
        Transition {
            NumberAnimation {
                target: __indicator
                property: "x"
                duration: 100
                easing.type: Easing.OutCirc
            }
        }
    ]

    Rectangle {
        id: __background
        anchors.centerIn: parent
        color: "#eef3dc"
        implicitWidth: parent.width
        implicitHeight: parent.height
        radius: 50
    }
    Rectangle {
        id: __indicator
        x: 0
        anchors.verticalCenter: __background.verticalCenter
        width: parent.width / 2
        height: parent.height + 20
        radius: width / 2
        color: "#4f6467"
    }

    MouseArea {
        id: __mosuearea
        anchors.fill: root
        onClicked: root.choosed = !root.choosed
    }
}
