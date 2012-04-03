import QtQuick 1.1
import "../js/utils.js" as Util

ImageButton {
    iconSource: "toolbar/btn_back"
    onClicked: {
        window.pageStack.pop()
    }
}
