import QtQuick 1.1
import com.nokia.symbian 1.1
import "../js/utils.js" as Util
import "../js/theme.js" as Theme

Image {
    id: splashPage
    state: "visible"
    property bool loaded: false;
    property alias text: loadingLabel.text

    onLoadedChanged: {
        if (loaded == false) {
            timer.start();
        }
    }

    source: Util.getImageFolder(false) + "common/bg.png"

    Column {
        width: parent.width - 2 * Theme.paddingLarge
        anchors.centerIn: parent
        spacing: 2 * Theme.paddingLarge

        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            source: Util.getImageFolder(false) + "common/splash.png"
            smooth: true
        }

        Label {
            id: loadingLabel
            text: "Nahrávam vtipy ..."
            anchors.horizontalCenter: parent.horizontalCenter
            platformInverted: window.platformInverted
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
        }
    }

    states: [
        State {
            name: "visible"
            PropertyChanges { target: splashPage; y: 0 }
            PropertyChanges { target: splashPage; opacity: 1 }
        },
        State {
            name: "hidden"
            when: splashPage.loaded && window.synchronize
            PropertyChanges { target: splashPage; y: window.height }
            PropertyChanges { target: splashPage; opacity: 0 }
        }
    ]

    transitions: [
        Transition {
            NumberAnimation { target: splashPage; properties: "y,opacity"; duration: 500 }
        }
    ]

    Timer {
        id: timer
        interval: 3000; running: true; repeat: false
        onTriggered: {
            splashPage.loaded = true;
        }
    }

    MouseArea {
        anchors.fill: parent
    }
}
