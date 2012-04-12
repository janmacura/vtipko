import QtQuick 1.1
import com.nokia.symbian 1.1
import "../js/utils.js" as Util
import "../js/theme.js" as Theme

Item {
    anchors.top: parent.top
    width: parent.width
    height: Theme.headerHeight
    property alias loading: busy.running

    Image {
        id: bgImage
        anchors.fill: parent
        smooth: true
        source: Util.getImageFolder(false) + "header/bg.png"
        fillMode: Image.TileHorizontally
    }

    Image {
        anchors.centerIn: parent
        smooth: true
        source: Util.getImageFolder(false) + "header/logo.png"
        MouseArea {
            anchors.fill: parent
            onClicked: {
                window.pageStack.push(Qt.resolvedUrl("../pages/AboutPage.qml"));
            }
        }
    }

    BusyIndicator {
        id: busy
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: Theme.paddingMedium
        running: false
        visible: running
    }
}
