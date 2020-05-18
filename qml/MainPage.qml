import QtQuick 2.0
import QtQuick.Controls 2.12

Page {
//    property alias debtormodel: debtormodel
//    property alias creditormodel: creditormodel
    MyToolBar { id: toolbar; z: 1; button.onClicked: drawer.open() }
    TabBar {
        anchors.top: toolbar.bottom
        z: 1
        id: tabBar
        currentIndex: view.currentIndex
        width: parent.width
        TabButton {
            text: qsTr("Debtors")
        }
        TabButton {
            text: qsTr("Creditors")
        }
    }

    SwipeView {
        id: view
        currentIndex: tabBar.currentIndex
        anchors.fill: parent


        Item {
            Rectangle {
                gradient: Gradient {
                    GradientStop { position: 0.5; color: "#57655c" }
                    GradientStop { position: 2.5; color: "#eef3dc" }
                }

                color: "#57655c"
                anchors.fill: parent
                MyListView {
                    id: debtorview
                    width: parent.width
                    height: parent.height - tabBar.height - toolbar.height - 10
                    y: tabBar.height + toolbar.height + 10
                    model: DebtorModel
                    delegate: ViewDelegate { width: debtorview.width; height: 80; iscreditor: false }
                }
                Text {
                    visible: debtorview.count < 1
                    anchors.centerIn: parent
                    text: "Congrats! There is no Debtors!"
                    color: "#cfcfcf"
                }

            }
        }

        Item {
            Rectangle {
                gradient: Gradient {
                    GradientStop { position: 0.5; color: "#57655c" }
                    GradientStop { position: 2.5; color: "#eef3dc" }
                }
                color: "#57655c"
                anchors.fill: parent
                MyListView {
                    id: creditorview
                    width: parent.width
                    height: parent.height
                    y: tabBar.height + toolbar.height + 10
                    model: CreditorModel
                    delegate: ViewDelegate { width: creditorview.width; height: 80; }
                }
                Text {
                    visible: creditorview.count < 1
                    anchors.centerIn: parent
                    text: "Congrats! There is no Creditors!"
                    color: "#cfcfcf"
                }
            }
        }
    }
    MyButton {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 30
        bgitem.implicitWidth: 50
        bgitem.implicitHeight: 50
        bgitem.radius: 25
        bgitem.color: area.containsPress ? Qt.darker("#fe615a") : "#fe615a"
        bgitem.border.width: 0
        text: ""
        font.pixelSize: 0
        Rectangle {
            id: horizontalplus
            anchors.centerIn: parent
            width: 22
            height: 5
            color: "#eef3d3"
        }
        Rectangle {
            anchors.horizontalCenter: horizontalplus.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            width: 5
            height: 20
            color: "#eef3d3"
        }
        onClicked: stackview.push(profilepage)
    }

    SidePane { id: drawer }
    Menu {
        id: delegatemenu
        property var index: 0
        property bool iscreditor: false
        function openforid(id, usertype) {
            delegatemenu.index = id
            delegatemenu.iscreditor = usertype
            delegatemenu.open()
        }

        MenuItem {
            text: "Delete"
            onTriggered: {
                delegatemenu.iscreditor ? CreditorModel.remove(delegatemenu.index) : DebtorModel.remove(delegatemenu.index)
            }
        }
    }
}
