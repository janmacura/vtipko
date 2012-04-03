import QtQuick 1.1
import "../js/utils.js" as Util
import com.nokia.symbian 1.1

Item {
    id: delegate
    width: ListView.view.width
    height: 0

    signal clicked(int index);
    property alias title: titleText.text
    property alias subtitle: subtitleText.text
    visible: height > 0 ? true : false

    BorderImage {
        id: bgImage
        anchors.fill: parent
        smooth: true
        source: mouseArea.pressed ? Util.getImageFolder(false) + "common/list_item_hover.png" : Util.getImageFolder(false) + "common/list_item.png"
        border.left: 100
        border.right: 100
    }

    Label {
        id: titleText
        anchors.left: parent.left
        anchors.leftMargin: platformStyle.paddingMedium
        anchors.right: subtitleText.left
        anchors.rightMargin: platformStyle.paddingMedium
        elide: Text.ElideRight
        anchors.verticalCenter: parent.verticalCenter
        color: Util.fontColorGreen
    }

    Label {
        id: subtitleText
        anchors.right: parent.right
        anchors.rightMargin: 60 + platformStyle.paddingMedium
        anchors.baseline: titleText.baseline
        color: Util.fontColorGray
        font.pixelSize: platformStyle.fontSizeSmall
    }


    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            delegate.clicked(index);
        }
    }
}
