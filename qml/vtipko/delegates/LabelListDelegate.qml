import QtQuick 1.1
import com.nokia.symbian 1.1
import "../js/utils.js" as Util
import "../js/theme.js" as Theme

Item {
    id: delegate

    width: ListView.view.width

    property string title: ""
    property string text: ""
    property string url: ""
    signal clicked;

    Label {
        id: titleLabel
        anchors.left: parent.left
        color: Theme.fontColorGray
        text: delegate.title;
        anchors.verticalCenter: parent.verticalCenter
    }

    Label {
        id: label
        anchors.left: titleLabel.right
        anchors.leftMargin: Theme.paddingMedium
        anchors.right: parent.right
        elide: Text.ElideRight
        text: delegate.text;
        color: delegate.url != "" ? Theme.fontColorGreen : Theme.fontColorGray
        font.underline: delegate.url != "" ? true : false
        anchors.verticalCenter: parent.verticalCenter
    }

    MouseArea {
        enabled: delegate.url != "" ? true : false
        anchors.fill: parent
        onClicked: {
            delegate.clicked()
        }
    }
}
