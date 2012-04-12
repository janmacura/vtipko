import QtQuick 1.1
import "../js/utils.js" as Util
import "../js/theme.js" as Theme

Item {
    width: parent.width
    height: Theme.headerHeight
    anchors.bottom: parent.bottom

    Image {
        id: bg
        source: Util.getImageFolder(false) + "toolbar/bg.png"
        anchors.fill: parent
        smooth: true
        fillMode: Image.TileHorizontally
    }
}
