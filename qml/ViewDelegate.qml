import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
Item {
    property bool iscreditor: true
    ColumnLayout {
        width: parent.width
        height: parent.height
        ItemDelegate {
            Layout.topMargin: 5
            Layout.fillWidth: true
            Layout.fillHeight: true
            onPressAndHold: {
                delegatemenu.x = 10
                delegatemenu.y = parent.parent.y + parent.parent.height + 30
                delegatemenu.openforid(index, iscreditor)
                delegatemenu.open()
            }
            onClicked: {
                stackview.profilepageModelindex = index
                stackview.profilepageEditMode = true
                stackview.profilepageModelIsCreditor = iscreditor
                stackview.profilepageModel = iscreditor ? CreditorModel : DebtorModel
                stackview.push(profilepage)
            }

            ColumnLayout {
                width: parent.width
                height: 60
                Rectangle {
                    color: "transparent"
                    Layout.fillWidth: true
                    height: 50
                    RoundedImage {
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        id: img
                        width: 50
                        height: 50
                        source: model.picurl
                        asynchronous: true
                        fillMode: Image.PreserveAspectCrop
                    }
                    Text {
                        id: name
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("%1 %2").arg(model.firstname).arg(model.lastname)
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: name.bottom
                        anchors.topMargin: 5
                        text: model.value
                    }
                }
            }
        }

        RowLayout {
            Item { width: mainwindow.width * 0.15; }
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 6
                color: "#959595"
                opacity: 0.5
                radius: 5
            }
        }
    }
}

