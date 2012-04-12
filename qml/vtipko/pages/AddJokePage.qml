import QtQuick 1.1
import com.nokia.symbian 1.1
import "../js/utils.js" as Util
import "../js/theme.js" as Theme
import "../components"

Page {
    id: mainPage
    property int category: -1
    property string xhr_type: "add"

    onCategoryChanged: {
        setCategory();
    }

    function setCategory() {
        for (var i = 0; i < categoriesModel.count; i++) {
            if (categoriesModel.get(i).category_id == mainPage.category) {
                categorySelectionDialog.selectedIndex = i;
                return
            }
        }
    }

    AppHeader {
        id: header
    }

    ListModel {
        id: categoriesModel
        Component.onCompleted: {
            Util.getCategories(categoriesModel);
        }
    }

    SelectionDialog {
        id: categorySelectionDialog
        titleText: "Vyber kategóriu"
        model: categoriesModel
        platformInverted: window.platformInverted
        delegate: MenuItem {
            platformInverted: window.platformInverted
            text: model.category_name
            onClicked: {
                selectedIndex = index
                root.accept()
            }
        }
    }

    Flickable {
        id: addFlickable
        anchors.top: header.bottom
        anchors.bottom: toolbar.top
        width: parent.width
        contentHeight: addColumn.height + 2 * Theme.paddingMedium
        clip: true
        Column {
            id: addColumn
            anchors.top: parent.top
            anchors.topMargin: Theme.paddingMedium
            width: parent.width - 2 * Theme.paddingMedium
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: Theme.paddingMedium

            Column {
                id: nameColumn
                width: parent.width
                spacing: Theme.paddingSmall
                Label {
                    text: "Názov vtipu";
                    color: Theme.fontColorGreen
                }
                TextField {
                    id: jokeName
                    width: parent.width
                }
            }

            Column {
                id: categoryColumn
                width: parent.width
                spacing: Theme.paddingSmall
                Label {
                    text: "Kategória";
                    color: Theme.fontColorGreen
                }
                Button {
                    width: parent.width
                    text: categorySelectionDialog.selectedIndex != -1 ? categoriesModel.get(categorySelectionDialog.selectedIndex).category_name : "Vyber kategóriu";
                    platformInverted: true
                    onClicked: {
                        categorySelectionDialog.open();
                    }
                }
            }

            Column {
                id: textColumn
                width: parent.width
                spacing: Theme.paddingSmall
                Label {
                    text: "Text vtipu";
                    color: Theme.fontColorGreen
                }
                TextArea {
                    id: jokeText
                    width: parent.width
                    height: 160
                }
            }

            Column {
                width: parent.width
                spacing: Theme.paddingSmall
                Label {
                    text: "Meno autora vtipu";
                    color: Theme.fontColorGreen
                }
                TextField {
                    id: jokeAutorName
                    width: parent.width
                }
            }

            Column {
                width: parent.width
                spacing: Theme.paddingSmall
                Label {
                    text: "Email autora";
                    color: Theme.fontColorGreen
                }
                TextField {
                    id: jokeAutorEmail
                    width: parent.width
                }
            }

            ImageButton {
                id: shareBtn
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Pridať vtip";
                onClicked: {
                    if (jokeName.text.trim() == "") {
                        addFlickable.contentY = nameColumn.y;
                        jokeName.forceActiveFocus();
                        jokeName.openSoftwareInputPanel();
                    } else if (categorySelectionDialog.selectedIndex == -1) {
                        addFlickable.contentY = categoryColumn.y;
                        categorySelectionDialog.open();
                    } else if (jokeText.text.trim() == "") {
                        addFlickable.contentY = textColumn.y;
                        jokeText.forceActiveFocus();
                        jokeText.openSoftwareInputPanel();
                    } else {
                        header.loading = true;
                        var params = new Object;
                        var url = "http://www.vtipko.eu/api/adddata";
                        params.sign = "test";
                        params.device = window.deviceinfo.imei;
                        params.text = jokeText.text;
                        params.category_id = categorySelectionDialog.model.get(categorySelectionDialog.selectedIndex).category_id;
                        params.name = jokeName.text;
                        params.author_name = jokeAutorName.text;
                        params.author_email = jokeAutorEmail.text;
                        var text = "Tvoj vtip bol odoslaný."
                        Util.xhrGet(url, params, text, mainPage.xhr_type, window);
                    }
                }
            }
        }
    }

    Connections {
        target: window
        ignoreUnknownSignals: true
        onXhrSuccess: {
            if (success && text == mainPage.xhr_type) {
                header.loading = false;
                window.pageStack.pop();
            } else if (!success && text == mainPage.xhr_type) {
                header.loading = false;
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
