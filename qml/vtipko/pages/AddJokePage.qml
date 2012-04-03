import QtQuick 1.1
import com.nokia.symbian 1.1
import "../js/utils.js" as Util
import "../components"

Page {
    id: mainPage

    AppHeader {
        id: header
    }

    ListModel {
        id: categoriesModel
        Component.onCompleted: {
            Util.getCategoryNames(categoriesModel);
        }
    }

    SelectionDialog {
        id: categorySelectionDialog
        titleText: "Vyber kategoriu"
        model: categoriesModel
        platformInverted: window.platformInverted
    }

    Flickable {
        id: addFlickable
        anchors.top: header.bottom
        anchors.bottom: toolbar.top
        width: parent.width
        contentHeight: addColumn.height + 2 * platformStyle.paddingMedium
        clip: true
        Column {
            id: addColumn
            anchors.top: parent.top
            anchors.topMargin: platformStyle.paddingMedium
            width: parent.width - 2 * platformStyle.paddingMedium
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: platformStyle.paddingMedium

            Column {
                width: parent.width
                spacing: platformStyle.paddingSmall
                Label {
                    text: qsTr("Nazov vtipu");
                    color: Util.fontColorGreen
                }
                TextField {
                    width: parent.width
                }
            }

            Column {
                width: parent.width
                spacing: platformStyle.paddingSmall
                Label {
                    text: qsTr("Kategoria");
                    color: Util.fontColorGreen
                }
                Button {
                    width: parent.width
                    text: categorySelectionDialog.selectedIndex != -1 ? categoriesModel.get(categorySelectionDialog.selectedIndex).name : qsTr("Vyber kategoriu");
                    platformInverted: true
                    onClicked: {
                        categorySelectionDialog.open();
                    }
                }
            }

            Column {
                width: parent.width
                spacing: platformStyle.paddingSmall
                Label {
                    text: qsTr("Text vtipu");
                    color: Util.fontColorGreen
                }
                TextArea {
                    width: parent.width
                    height: 160
                }
            }

            Column {
                width: parent.width
                spacing: platformStyle.paddingSmall
                Label {
                    text: qsTr("Meno autora vtipu");
                    color: Util.fontColorGreen
                }
                TextField {
                    width: parent.width
                }
            }

            Column {
                width: parent.width
                spacing: platformStyle.paddingSmall
                Label {
                    text: qsTr("Email autora");
                    color: Util.fontColorGreen
                }
                TextField {
                    width: parent.width
                }
            }

            ImageButton {
                id: shareBtn
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Pridat vtip");
                onClicked: {
                    console.log("pridat vtip");
                }
            }
        }
    }

    ScrollBar {
        flickableItem: addFlickable
        interactive: true
        anchors { right: addFlickable.right; top: addFlickable.top }
    }

    AppToolBar {
        id: toolbar
        BackButton {
            anchors.left: parent.left
        }
    }
}
