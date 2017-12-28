import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.VirtualKeyboard 2.1
import QtWebEngine 1.2

Window {
    id: mainWindow
    width: 1024
    height: 750
    visible: true
    visibility: Window.FullScreen

    function load(url) {
        webEngineView.url = url;
    }

    Shortcut {
        sequence: "Alt+F4"
        onActivated: Qt.quit()
    }

    Item {
        id: appContainer
        width: Screen.width < Screen.height ? parent.height : parent.width
        height: Screen.width < Screen.height ? parent.width : parent.height
        anchors.centerIn: parent
        rotation: Screen.width < Screen.height ? 90 : 0

        WebEngineView {
            id: webEngineView
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: inputPanel.top
            /* url: "http://www.qt.io" */
        }

        InputPanel {
            id: inputPanel
            z: 89
            y: appContainer.height
            anchors.left: parent.left
            anchors.right: parent.right
            states: State {
                name: "visible"
                when: inputPanel.active
                PropertyChanges {
                    target: inputPanel
                    y: appContainer.height - inputPanel.height
                }
            }
        }
    }
}
