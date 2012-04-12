import QtQuick 1.1

ImageButton {
    iconSource: "toolbar/btn_back"
    onClicked: {
        window.pageStack.pop()
    }
}
