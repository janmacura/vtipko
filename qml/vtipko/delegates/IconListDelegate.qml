import QtQuick 1.1
import com.nokia.symbian 1.1
import "../js/utils.js" as Util
import "../js/theme.js" as Theme

Item {
    id: delegate

    width: ListView.view.width

    property string iconPath: ""
    property string text: ""
    property string url: ""

    signal clicked

    Image {
        id: icon
        source: delegate.iconPath != "" ? Util.getImageFolder(false) + delegate.iconPath : ""
        anchors.verticalCenter: parent.verticalCenter
        width: source != "" ? 30 : 0
        smooth: true
        fillMode: Image.PreserveAspectFit
    }

    Label {
        id: label
        anchors.left: icon.right
        anchors.leftMargin: icon.source != "" ? Theme.paddingMedium : 0
        anchors.right: parent.right
        wrapMode: Text.NoWrap
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
            delegate.clicked();
        }
    }
}
