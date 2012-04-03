import QtQuick 1.1
import com.nokia.symbian 1.1
import "../js/utils.js" as Util

BorderImage {
    id: btn
    signal clicked();
    property string iconSource: "common/btn";
    property alias text: textLabel.text
    property variant btnColor: Util.fontColorButton
    property variant btnColorHover: Util.fontColorButtonHover

    source: mouseArea.pressed ? (Util.getImageFolder(false) + iconSource + "_hover.png") : (Util.getImageFolder(false) + iconSource + ".png")
    smooth: true

    Label {
        id: textLabel
        anchors.top: parent.top
        anchors.topMargin: mouseArea.pressed ? platformStyle.paddingMedium + 3 : platformStyle.paddingMedium

        anchors.left: parent.left
        anchors.leftMargin: mouseArea.pressed ? (8 + platformStyle.paddingMedium + 3) : (8 + platformStyle.paddingMedium)

        anchors.right: parent.right
        anchors.rightMargin: 14 + platformStyle.paddingMedium

        horizontalAlignment: Text.AlignHCenter
        visible: text == "" ? false : true
        color: mouseArea.pressed ? btnColorHover : btn.btnColor
        font.pixelSize: platformStyle.fontSizeLarge
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            btn.clicked();
        }
    }
}
