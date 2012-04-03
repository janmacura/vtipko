import QtQuick 1.1
import com.nokia.symbian 1.1
import "../js/utils.js" as Util

Image {
    id: splashPage
    state: "visible"
    property bool loaded: false;

    source: Util.getImageFolder(false) + "common/bg.png"

    Image {
        anchors.centerIn: parent
        source: Util.getImageFolder(false) + "common/splash.png"
        smooth: true
    }

    Column {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 100
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: platformStyle.paddingMedium

        BusyIndicator {
            anchors.horizontalCenter: parent.horizontalCenter
            running: true
            platformInverted: window.platformInverted
        }

        Label {
            text: "Nahravam vtipy ..."
            anchors.horizontalCenter: parent.horizontalCenter
            platformInverted: window.platformInverted
        }
    }

    states: [
        State {
            name: "visible"
            PropertyChanges { target: splashPage; y: 0 }
        },
        State {
            name: "hidden"
            when: splashPage.loaded && window.synchronize
            PropertyChanges { target: splashPage; y: window.height }
        }
    ]

    transitions: [
        Transition {
            SequentialAnimation {
                NumberAnimation { target: splashPage; properties: "y"; duration: 500 }
                ScriptAction {
                    script: splashPage.destroy();
                }
            }
        }
    ]

    Timer {
        interval: 1000; running: true; repeat: false
        onTriggered: {
            splashPage.loaded = true;
        }
    }

    MouseArea {
        anchors.fill: parent
    }
}
