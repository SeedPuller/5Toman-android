import QtQuick 2.0
import QtQuick.Controls 2.12

SpinBox {
    id: spbox
    to: 1000 * 1000
    stepSize: 5000
    width: 75
    height: 25
    up.indicator: Rectangle {
        id: upindicator
        anchors.right: __bg.right
        anchors.verticalCenter: __bg.verticalCenter
        color: "transparent"
        width: 40
        height: 40
        Image {
            id: upindicatorimage
            anchors.left: parent.left
            anchors.leftMargin: width - 15
            anchors.verticalCenter: parent.verticalCenter
            smooth: true
            width: 40
            height: 40
            fillMode: Image.PreserveAspectCrop
            source: "pic/plus.svg"
        }
        Label {
            anchors.centerIn: upindicatorimage
            text: "+"
            font.pixelSize: 20
            font.bold: Font.Bold
            color: "black"
        }

        MouseArea {
            id: upindicatorarea
            anchors.fill: upindicatorimage
            onClicked: {
                spbox.increase()
            }
        }
        Rectangle {
            visible: upindicatorarea.containsPress
            anchors.fill: upindicatorimage
            radius: upindicatorimage.width / 2
            color: "grey"
            opacity: 0.5
        }

    }


    down.indicator: Rectangle {
        id: downindicator
        anchors.left: __bg.left
        anchors.verticalCenter: __bg.verticalCenter
        color: "transparent"
        width: 40
        height: 40
        Image {
            id: downindicatorimage
            anchors.right: parent.right
            anchors.rightMargin: width - 15
            anchors.verticalCenter: parent.verticalCenter
            smooth: true
            width: 40
            height: 40
            fillMode: Image.PreserveAspectCrop
            source: "pic/minus.svg"
        }
        Label {
            visible: downindicator.enabled
            anchors.centerIn: downindicatorimage
            text: "-"
            font.pixelSize: 20
            font.bold: Font.Bold
            color: "black"
        }
        MouseArea {
            id: downindicatorarea
            anchors.fill: downindicatorimage
            onClicked: spbox.decrease()
        }
        Rectangle {
            visible: downindicatorarea.containsPress
            anchors.fill: downindicatorimage
            radius: downindicatorimage.width / 2
            color: "grey"
            opacity: 0.5
        }
    }

    contentItem: Rectangle {
        color: "transparent"
        anchors.centerIn: __bg
        Text {
            anchors.centerIn: parent
            text: spbox.value
        }
    }

    background: Rectangle {
        id: __bg
        implicitWidth: 100
        implicitHeight: 25
        color: "#eef3dc"
        radius: 10
        opacity: 0.6
    }
}
