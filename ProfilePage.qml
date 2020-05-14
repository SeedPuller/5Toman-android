import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.2

Page {
    id: profpage
    property string textcolor: "black"
    property bool editmode: false
    property bool iscreditor: false
    property var index: -1
    property var roles: {"id": 0, "firstname": 1, "lastname": 2, "value": 3, "picurl": 4}
    property var model: {
        if (iscreditor) {
            return CreditorModel.getIndexData(index)
        }
//        return stackview.get(0).debtormodel.get(index)
        return DebtorModel.getIndexData(index)
    }

    function clearup() {
        editmode = false
    }

    width: mainwindow.width
    height: mainwindow.height

    header: MyToolBar {
        text.text: "Profile"
        button.onClicked: {
            clearup()
            stackview.pop()
        }
        button.text: "\ue801" // return icon
        font.family: "fontello"
    }

    Rectangle {
        width: parent.width
        height: parent.height
        gradient: Gradient {
            GradientStop { position: 0.5; color: "#57655c" }
            GradientStop { position: 2.5; color: "#eef3dc" }
        }
        color: "#57655c"
    }
    ColumnLayout {
        width: parent.width
        height: parent.height
        spacing: 0
        RoundedImage {
            id: profimage
            fillMode: Image.PreserveAspectCrop
            sourceSize.width: 748
            sourceSize.height: 748
            Layout.preferredWidth: mainwindow.width * 0.4
            Layout.preferredHeight: mainwindow.width * 0.4
            Layout.alignment: Qt.AlignHCenter
            asynchronous: true
            source: {
                if (editmode && model[0] != undefined) {
                    return model[roles["picurl"]]
                }
                return "pic/default-profile-pic.png"

            }

            Rectangle {
                id: changerect
                anchors.fill: parent
                color: "grey"
                opacity: 0.7
                Text {anchors.centerIn: parent; text: "Change"; font.pixelSize: 20 }
            }
            MouseArea {
                id: imgmousearea
                anchors.fill: parent
                onClicked: imageactionmenu.open()
            }
            Menu {
                id: imageactionmenu
                y: profimage.height / 2
                MenuItem {
                    text: "Remove"
                    onTriggered: profimage.source = "pic/default-profile-pic.png"
                }
                MenuItem {
                    text: "Pick Photo"
                    onTriggered: filedialog.open()
                }
            }
        }
        Label {
            id: firstnamelabel
            Layout.leftMargin: mainwindow.width * 0.12
            text: "First Name:"
            font.bold: Font.Medium
            color: textcolor
        }

        TextField {
            id: firstnameinput
            Layout.alignment: Qt.AlignHCenter
            placeholderText: "Type here"
            Layout.preferredWidth: mainwindow.width * 0.75
            text: {
                if (editmode && model[0] != undefined) {
                    return model[roles["firstname"]]
                }
                return ""
            }
        }
        Label {
            Layout.leftMargin: mainwindow.width * 0.12
            text: "Last Name:"
            color: textcolor
            font.bold: Font.Medium
        }

        TextField {
            id: lasttnameinput
            Layout.alignment: Qt.AlignHCenter
            placeholderText: "Type here"
            Layout.preferredWidth: mainwindow.width * 0.75
            text: {
                if (editmode && model[0] != undefined) {
                    return model[roles["lastname"]]
                }
                return ""
            }

        }

        MySpinBox {
            id: valueinput
            Layout.preferredWidth: 85
            Layout.preferredHeight: 25
            Layout.topMargin: 20
            Layout.alignment: Qt.AlignHCenter
            value: {
                if (editmode && model[0] != undefined) {
                    return Number(model[roles["value"]])
                }
                return 0
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 30
            spacing: 15
            Label {
                text: "Debtor"
                color: textcolor
                font.bold: Font.Medium
            }
            MySwitch {
                id: roleinput
                Layout.preferredWidth: 80
                Layout.preferredHeight: 20
                choosed: iscreditor
            }

            Label {
                text: "Creditor"
                color: textcolor
                font.bold: Font.Medium
            }
        }

        MyButton {
            id: editbutton
            Layout.alignment: Qt.AlignRight
            Layout.rightMargin: 50
            Layout.bottomMargin: 50
            text: "Save"
            contentText.color: "black"
            contentText.font.pixelSize: 15
            contentText.font.bold: Font.Medium
            bgitem.radius: 20
            bgitem.border.width: 0
            bgitem.implicitWidth: 80
            bgitem.implicitHeight: 30
            bgitem.color: "#fe615a"
            onClicked: {
                var isusertypecreditor = roleinput.choosed
                if (!editmode) {
                    if (isusertypecreditor) {
                        CreditorModel.insertFirst(firstnameinput.text,
                                                lasttnameinput.text,
                                                valueinput.value,
                                                profimage.source.toString())
                        CreditorModel.updateTotalValue()
                        stackview.pop()
                        return
                    }
                    DebtorModel.insertFirst(firstnameinput.text,
                                            lasttnameinput.text,
                                            valueinput.value,
                                            profimage.source.toString())
                    DebtorModel.updateTotalValue()
                    stackview.pop()
                    return
                }
                // edit mode

                // check if user type changed
                if (isusertypecreditor != iscreditor) {
                    changeUserType(isusertypecreditor)
                    DebtorModel.updateTotalValue()
                    CreditorModel.updateTotalValue()
                    clearup()
                    stackview.pop()
                    return
                }

                if (isusertypecreditor) {
                    CreditorModel.setData(index, firstnameinput.text, roles["firstname"])
                    CreditorModel.setData(index, lasttnameinput.text, roles["lastname"])
                    CreditorModel.setData(index, valueinput.value, roles["value"])
                    CreditorModel.setData(index, profimage.source.toString(), roles["picurl"])
                    CreditorModel.updateDB(index)
                } else {
                    DebtorModel.setData(index, firstnameinput.text, roles["firstname"])
                    DebtorModel.setData(index, lasttnameinput.text, roles["lastname"])
                    DebtorModel.setData(index, valueinput.value, roles["value"])
                    DebtorModel.setData(index, profimage.source.toString(), roles["picurl"])
                    DebtorModel.updateDB(index)
                }
                clearup()
                stackview.pop()
            }
        }
    }

    FileDialog {
        id: filedialog
        title: "choose file"
        folder: shortcuts.home
//        property var index: 0
        function makeenable(indexnum) {
            index = Number(indexnum)
            fdialog.visible = true
        }
        onAccepted: {
            profimage.source = filedialog.fileUrl
        }
    }

    function changeUserType(temp) {
        if (temp) {
            DebtorModel.remove(profpage.index)
            CreditorModel.insertFirst(firstnameinput.text,
                                    lasttnameinput.text,
                                    valueinput.value,
                                    profimage.source.toString())

        } else {
            CreditorModel.remove(profpage.index)
            DebtorModel.insertFirst(firstnameinput.text,
                                    lasttnameinput.text,
                                    valueinput.value,
                                    profimage.source.toString())
        }
        DebtorModel.updateTotalValue()
        CreditorModel.updateTotalValue()
    }
}
