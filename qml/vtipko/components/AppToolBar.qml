import QtQuick 1.1
import "../js/utils.js" as Util

Item {
    width: parent.width
    height: Util.headerHeight
    anchors.bottom: parent.bottom

    BorderImage {
        id: bg
        source: Util.getImageFolder(false) + "toolbar/bg.png"
        anchors.fill: parent
        smooth: true
        border.left: 100;
        border.right: 100;
    }
}
