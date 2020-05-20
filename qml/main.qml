import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

ApplicationWindow {
    visible: true
    width: 480
    height: 640
    title: "5Toman"
    id: mainwindow
    FontLoader { source: "fonts/fontello.ttf" }

    StackView {
        focus: true
        anchors.fill: parent
        id: stackview
        initialItem: mainpage
        Keys.onBackPressed: stackview.depth > 1 ? stackview.pop() : Qt.quit()

        /*
          these are parameters for ProfilePage. there is better way to do this probably
        */
        property bool profilepageEditMode: false
        property bool profilepageModelIsCreditor
        property var profilepageModel
        property real profilepageModelindex: -1
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
