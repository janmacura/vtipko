import QtQuick 1.1
import com.nokia.symbian 1.1
import "../js/utils.js" as Util
import "../js/theme.js" as Theme


Item {
    id: delegate
    width: ListView.view.width
    height: Theme.listHeight;

    signal clicked(int index);
    property alias title: titleText.text
    property alias subtitle: subtitleText.text
    property alias arrowVisible: arrow.visible
    property int categoryNumber: 0;

    BorderImage {
        id: bgImage
        anchors.fill: parent
        source: mouseArea.pressed ? Util.getImageFolder(false) + "common/list_item_hover2.png" : Util.getImageFolder(false) + "common/list_item2.png"
        border.left: 100
        border.right: 100
    }

    Label {
        id: titleText
        anchors.left: parent.left
        anchors.leftMargin: Theme.paddingMedium
        anchors.right: subtitleText.left
        anchors.rightMargin: Theme.paddingMedium
        elide: Text.ElideRight
        anchors.verticalCenter: parent.verticalCenter
        color: Theme.fontColorGreen
    }

    Label {
        id: subtitleText
        anchors.right: parent.right
        anchors.rightMargin: arrow.width + Theme.paddingMedium
        anchors.baseline: titleText.baseline
        color: Theme.fontColorGray
        font.pixelSize: Theme.fontSizeSmall
        opacity: 0.5
    }

    Item {
        id: arrow
        width: 60
        height: parent.height
        anchors.right: parent.right
        Image {
            source: Util.getImageFolder(false) + (categoryNumber > 0 ? "common/arrow.png" : "common/btn_new.png")
            anchors.centerIn: parent
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            delegate.clicked(index);
        }
    }
}
