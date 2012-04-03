import QtQuick 1.1
import "../js/utils.js" as Util
import com.nokia.symbian 1.1

Item {
    id: delegate

    width: ListView.view.width
    height: Math.max(titleLabel.height, label.height) + platformStyle.paddingSmall

    property string title: ""
    property string text: ""
    property string url: ""

    Label {
        id: titleLabel
        anchors.left: parent.left
        color: Util.fontColorGray
        text: qsTr(delegate.title);
    }

    Label {
        id: label
        anchors.left: titleLabel.right
        anchors.leftMargin: platformStyle.paddingMedium
        anchors.right: parent.right
        elide: Text.ElideRight
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
