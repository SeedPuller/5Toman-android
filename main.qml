import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
ApplicationWindow {
    visible: true
    width: 480
    height: 640
    title: "5Toman"
    id: mainwindow


    StackView {
        anchors.fill: parent
        id: stackview
        initialItem: mainpage
        Keys.onBackPressed: stackview.depth > 1 ? stackview.pop() : {}
//        Keys.onReturnPressed: stackview.depth > 1 ? stackview.pop() : {}
    }

    Component {
        id: mainpage
        MainPage { }
    }

    Component {
        id: aboutpage
        AboutPage { }
    }

    Component {
        id: profilepage
        ProfilePage { }
    }
}
