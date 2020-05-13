import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

Drawer {
    FontLoader { source: "fonts/fontello.ttf" }
    readonly property string textcolor: "#cfcfcf"
    readonly property bool inPortrait: true
    width: mainwindow.width / 2
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
            height: 50
            Text {
                text: "5Toman"
                font.pixelSize: 20
                color: "#cfcfcf"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
            }
        }

        footer: ItemDelegate {
            id: footer
            width: parent.width
            RowLayout {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 14
                spacing: 10
                Text {
                    id: aboutsign
                    text: "\uf129" // information sign
                    color: textcolor
                    font.family: "fontello"
                    font.pixelSize: 15
                }
                Text {
                    text: "About"
                    color: textcolor
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
            height: 50
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
                anchors.leftMargin: 10
                Text {
                    id: sign
                    text: model.sign
                    color: textcolor
                    font.family: "fontello"
                    font.pixelSize: 15
                }
                Text {
                    text: model.title
                    color: textcolor
                }
            }
            Text {
                id: sumsection
                visible: false
                anchors.top: titlesection.bottom
                anchors.left: titlesection.left
                anchors.leftMargin: 15
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
