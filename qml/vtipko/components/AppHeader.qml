import QtQuick 1.1
import "../js/utils.js" as Util

Item {
    anchors.top: parent.top
    width: parent.width
    height: Util.headerHeight

    BorderImage {
        id: bgImage
        anchors.fill: parent
        smooth: true
        source: Util.getImageFolder(false) + "header/bg.png"
        border.left: 100
        border.right: 100
    }

    Image {
        anchors.centerIn: parent
        smooth: true
        source: Util.getImageFolder(false) + "header/logo.png"
    }
}
