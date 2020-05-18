import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

Drawer {

    readonly property string textcolor: "#cfcfcf"
    readonly property bool inPortrait: true
    width: mainwindow.width / 1.5
    height: mainwindow.height

    modal: inPortrait
    interactive: inPortrait
    position: inPortrait ? 0 : 1
    visible: !inPortrait

    ListView {
        id: listView
        anchors.fill: parent

        headerPositioning: ListView.OverlayHeader

        header: Rectangle {
            color: "#526158"
            width: parent.width
            height: 70
            Text {
                text: "5Toman"
                font.pixelSize: 20
                color: "#cfcfcf"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 30
            }
        }

        footer: ItemDelegate {
            id: footer
            width: parent.width
            height: 80
            RowLayout {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 34
                spacing: 34
                Text {
                    id: aboutsign
                    text: "\uf129" // information sign
                    color: textcolor
                    font.family: "fontello"
                    font.pixelSize: 20
                }
                Text {
                    text: "About"
                    color: textcolor
                    font.pixelSize: 15
                    font.bold: Font.Bold
                }
            }
            MenuSeparator {
                parent: footer
                width: parent.width
                anchors.verticalCenter: parent.top
            }

            onClicked: {
                drawer.close()
//                pageloader.source = "AboutPage.qml"
                stackview.push(aboutpage)
            }
        }

        model: ListModel {
            // \ue800 is plus sign
            ListElement { sign: "\ue800"; title: "All Debts"; iscredit: false}
            ListElement { sign: "\ue800"; title: "All Credits"; iscredit: true}

        }

        delegate: ItemDelegate {
            id: itemdeleg
            property bool expandmode: false
            state: expandmode ? "expand" : "not-expand"
            onClicked: expandmode = !expandmode
            width: parent.width
            height: 80
            states: [
                State {
                    name: "expand"
                    PropertyChanges { target: sign; rotation: 45 }
                    PropertyChanges { target: itemdeleg; height: 65 }
                    PropertyChanges { target: sumsection; visible: true }
                },
                State {
                    name: "not-expand"
                    PropertyChanges { target: sign; rotation: 0 }
                    PropertyChanges { target: itemdeleg; height: 50 }
                    PropertyChanges { target: sumsection; visible: false }
                }
            ]
            transitions: [
                    Transition {
                    RotationAnimation {
                        target: sign
                        duration: 200
                        easing.type: Easing.InOutQuad
                    }

                    NumberAnimation {
                        target: sumsection
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: 200
                        easing.type: Easing.InOutQuad
                    }
                }
            ]

            Behavior on height {
                NumberAnimation {
                    duration: 200
                }
            }

            RowLayout {
                id: titlesection
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 30
                spacing: 34
                Text {
                    id: sign
                    text: model.sign
                    color: textcolor
                    font.family: "fontello"
                    font.pixelSize: 20
                }
                Text {
                    text: model.title
                    color: textcolor
                    font.pixelSize: 15
                    font.bold: Font.Bold
                }
            }
            Text {
                id: sumsection
                visible: false
                anchors.top: titlesection.bottom
                anchors.left: titlesection.left
                anchors.leftMargin: 55
                color: textcolor
                text: {
                    if (DebtorModel != null && CreditorModel != null) {
                        return model.iscredit ? CreditorModel.totalvalue : DebtorModel.totalvalue
                    }
                    return 0;
                }
            }
        }
    }
}
