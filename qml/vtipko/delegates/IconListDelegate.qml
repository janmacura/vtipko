import QtQuick 1.1
import "../js/utils.js" as Util
import com.nokia.symbian 1.1

Item {
    id: delegate

    width: ListView.view.width
    height: Math.max(icon.height, label.height) + platformStyle.paddingSmall

    property string iconPath: ""
    property string text: ""
    property string url: ""

    Image {
        id: icon
        source: delegate.iconPath != "" ? Util.getImageFolder(false) + delegate.iconPath : ""
        anchors.verticalCenter: parent.verticalCenter
        width: source != "" ? 50 : 0
    }

    Label {
        id: label
        anchors.left: icon.right
        anchors.leftMargin: icon.source != "" ? platformStyle.paddingMedium : 0
        anchors.right: parent.right
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        text: qsTr(delegate.text);
        color: delegate.url != "" ? Util.fontColorGreen : Util.fontColorGray
        font.underline: delegate.url != "" ? true : false
        anchors.verticalCenter: parent.verticalCenter
    }

    MouseArea {
        enabled: delegate.url != "" ? true : false
        anchors.fill: parent
        onClicked: {
            console.log(delegate.url);
            Qt.openUrlExternally(delegate.url);
        }
    }
}
