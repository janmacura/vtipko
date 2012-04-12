import QtQuick 1.1
import com.nokia.symbian 1.1
import "../js/utils.js" as Util
import "../js/theme.js" as Theme

BorderImage {
    id: btn
    signal clicked();
    property string iconSource: "common/btn";
    property alias text: textLabel.text
    property variant btnColor: Theme.fontColorButton
    property variant btnColorHover: Theme.fontColorButtonHover

    source: mouseArea.pressed ? (Util.getImageFolder(false) + iconSource + "_hover.png") : (Util.getImageFolder(false) + iconSource + ".png")
    smooth: true

    Label {
        id: textLabel
        anchors.top: parent.top
        anchors.topMargin: mouseArea.pressed ? Theme.paddingMedium + 3 : Theme.paddingMedium

        anchors.left: parent.left
        anchors.leftMargin: mouseArea.pressed ? (8 + Theme.paddingMedium + 3) : (8 + Theme.paddingMedium)

        anchors.right: parent.right
        anchors.rightMargin: 14 + Theme.paddingMedium

        horizontalAlignment: Text.AlignHCenter
        visible: text == "" ? false : true
        color: mouseArea.pressed ? btnColorHover : btn.btnColor
        font.pixelSize: Theme.fontSizeLarge
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            btn.clicked();
        }
    }
}
