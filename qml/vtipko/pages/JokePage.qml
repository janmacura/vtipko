import QtQuick 1.1
import com.nokia.symbian 1.1
import com.nokia.extras 1.1
import "../js/utils.js" as Util
import "../components"

Page {
    id: mainPage
    property string category_id: "";

    onCategory_idChanged: {
        Util.getCategoryJokes(category_id, categoryJokesModel);
    }

    AppHeader {
        id: header
    }

    ListModel {
        id: categoryJokesModel
    }

    ListView {
        id: listview
        anchors.top: header.bottom
        anchors.bottom: footer.top
        anchors.bottomMargin: platformStyle.paddingMedium
        width: parent.width
        clip: true
        model: categoryJokesModel
        snapMode: ListView.SnapOneItem
        orientation: ListView.Horizontal
        highlightRangeMode: ListView.StrictlyEnforceRange
        delegate: Item {
            id: delegate
            width: ListView.view.width
            height: ListView.view.height

            BorderImage {
                id: jokeHeaderBg
                anchors.top: parent.top
                width: parent.width
                height: column.height + 36 + 2 * platformStyle.paddingMedium
                anchors.horizontalCenter: parent.horizontalCenter
                source: Util.getImageFolder(false) + "common/title_bg.png"
                border {
                    left: 2 * platformStyle.paddingLarge
                    right: 2* platformStyle.paddingLarge
                    top: 2 * platformStyle.paddingLarge
                    bottom: 2 * platformStyle.paddingLarge
                }

                Image {
                    id: favorite
                    anchors.left: parent.left
                    anchors.leftMargin: 18 + platformStyle.paddingSmall
                    anchors.top: parent.top
                    anchors.topMargin: 18 + platformStyle.paddingMedium
                    source: Util.getImageFolder(false) + "common/faves_0.png"
                }

                Column {
                    id: column
                    anchors.left: favorite.right
                    anchors.leftMargin: platformStyle.paddingMedium
                    anchors.right: parent.right
                    anchors.rightMargin: 18 + platformStyle.paddingMedium
                    anchors.top: parent.top
                    anchors.topMargin: 18 + platformStyle.paddingMedium

                    Label {
                        text: model.joke_name
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        width: parent.width
                        color: Util.fontColorBlue
                    }

                    Item {
                        width: parent.width
                        height: childrenRect.height

                        Label {
                            text: Util.getCategoryNameById(model.joke_category_id);
                            font.pixelSize: platformStyle.fontSizeSmall
                            anchors.left: parent.left
                            anchors.right: jokeNumberText.left
                            anchors.rightMargin: platformStyle.paddingMedium
                            elide: Text.ElideRight
                            color: Util.fontColorGray
                        }

                        Label {
                            id: jokeNumberText
                            text: (delegate.ListView.view.currentIndex + 1) + " / " + categoryJokesModel.count
                            font.pixelSize: platformStyle.fontSizeSmall
                            anchors.right: parent.right
                            color: Util.fontColorGray
                        }
                    }
                }
            }

            BorderImage {
                id: jokeTextBg
                anchors.top: jokeHeaderBg.bottom
                anchors.bottom: parent.bottom
                width: parent.width
                height: column.height + 72 + 2 * platformStyle.paddingMedium
                anchors.horizontalCenter: parent.horizontalCenter
                source: Util.getImageFolder(false) + "common/content_bg.png"
                border {
                    left: 2 * platformStyle.paddingLarge
                    right: 2* platformStyle.paddingLarge
                    top: 2 * platformStyle.paddingLarge
                    bottom: 2 * platformStyle.paddingLarge
                }

                Flickable {
                    id: jokeTextFlickable
                    anchors.left: parent.left
                    anchors.leftMargin: 18 + platformStyle.paddingMedium
                    anchors.right: parent.right
                    anchors.rightMargin: 18 + platformStyle.paddingMedium
                    anchors.top: parent.top
                    anchors.topMargin: 18 + platformStyle.paddingMedium
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 56 + platformStyle.paddingMedium
                    contentHeight: jokeText.height
                    clip: true

                    Label {
                        id: jokeText
                        width: parent.width

                        text: model.joke_text
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        color: Util.fontColorGray
                    }
                }

                AppRatingIndicator {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 18
                    anchors.right: parent.right
                    anchors.rightMargin: 18 + platformStyle.paddingMedium
                    maximumValue: 5
                    ratingValue : 3
                    onClicked: {
                        console.log(index);
                        if (index == 0 && ratingValue == 1)
                            ratingValue = 0
                        else
                            ratingValue = index + 1;
                    }
                }

                ScrollBar {
                    flickableItem: jokeTextFlickable
                    interactive: true
                    anchors { right: parent.right; top: jokeTextFlickable.top }
                }
            }
        }
    }

    Item {
        id: footer
        width: parent.width - 2 * platformStyle.paddingMedium
        height: Math.max(shareBtn.height, previousBtn.height)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: toolbar.top
        anchors.bottomMargin: platformStyle.paddingMedium

        ImageButton {
            id: previousBtn
            anchors.left: parent.left
            anchors.leftMargin: platformStyle.paddingMedium
            anchors.verticalCenter: parent.verticalCenter
            iconSource: "common/left"
            onClicked: {
                listview.decrementCurrentIndex();
            }
            visible: listview.currentIndex == 0 ? false : true
        }

        ImageButton {
            id: shareBtn
            anchors.centerIn: parent
            text: qsTr("Zdielat");
            onClicked: {
                shareMenu.open();
            }
        }

        ImageButton {
            id: nextBtn
            anchors.right: parent.right
            anchors.rightMargin: platformStyle.paddingMedium
            anchors.verticalCenter: parent.verticalCenter
            iconSource: "common/right"
            onClicked: {
                listview.incrementCurrentIndex();
            }
            visible: listview.currentIndex == listview.count - 1 ? false : true
        }
    }

    AppToolBar {
        id: toolbar
        BackButton {
            anchors.left: parent.left
        }

        ImageButton {
            iconSource: "toolbar/btn_new"
            anchors.centerIn: parent
            onClicked: {
                window.pageStack.push(Qt.resolvedUrl("AddJokePage.qml"));
            }
        }
        ImageButton {
            iconSource: "toolbar/btn_menu"
            anchors.right: parent.right
            onClicked: {
                mainMenu.open();
            }
        }
    }

    Menu {
        id: mainMenu
        platformInverted: window.platformInverted
        content: MenuLayout {
            MenuItem {
                text: qsTr("Pridat vtip");
                platformInverted: window.platformInverted
                onClicked: {
                    window.pageStack.push(Qt.resolvedUrl("AddJokePage.qml"));
                }
            }
            MenuItem {
                text: qsTr("Nahlas");
                platformInverted: window.platformInverted
                onClicked: {
                    dialog.open();
                }
            }
            MenuItem {
                text: qsTr("O vtipkovi");
                platformInverted: window.platformInverted
                onClicked: {
                    window.pageStack.push(Qt.resolvedUrl("AboutPage.qml"));
                }
            }
            MenuItem {
                text: qsTr("Navrat");
                platformInverted: window.platformInverted
                onClicked: {
                    window.pageStack.pop()
                }
            }
        }
    }

    Menu {
        id: shareMenu
        platformInverted: window.platformInverted
        content: MenuLayout {
            MenuItem {
                text: qsTr("Facebook");
                platformInverted: window.platformInverted
                onClicked: {
                }
            }
            MenuItem {
                text: qsTr("Twitter");
                platformInverted: window.platformInverted
                onClicked: {
                }
            }
            MenuItem {
                text: qsTr("SMS");
                platformInverted: window.platformInverted
                onClicked: {
                }
            }
            MenuItem {
                text: qsTr("E-mail");
                platformInverted: window.platformInverted
                onClicked: {
                }
            }
        }
    }

    SelectionDialog {
        id: reportSelectionDialog
        titleText: qsTr("Vyber moznost");
        platformInverted: window.platformInverted
        model: ListModel {
            ListElement { name: "Chyba vo vtipe"}
            ListElement { name: "Nevhodny vtip"}
            ListElement { name: "Spam"}
            ListElement { name: "Ine"}
        }
    }

    CommonDialog {
        id: dialog
        titleText: qsTr("Nahlasit vtip");
        buttonTexts: ["Odoslat", "Zrusit"]
        platformInverted: window.platformInverted
        content: Item {
            width: parent.width
            height: columnDialog.height + 2 * platformStyle.paddingMedium

            Column {
                id: columnDialog
                anchors.top: parent.top
                anchors.topMargin: platformStyle.paddingMedium
                width: parent.width - 2 * platformStyle.paddingMedium
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: platformStyle.paddingMedium

                Column {
                    width: parent.width
                    spacing: platformStyle.paddingSmall
                    Label {
                        text: qsTr("Nahlas");
                        platformInverted: window.platformInverted
                    }
                    Button {
                        width: parent.width
                        text: reportSelectionDialog.selectedIndex != -1 ? reportSelectionDialog.model.get(reportSelectionDialog.selectedIndex).name : qsTr("Vyber moznost");
                        platformInverted: window.platformInverted
                        onClicked: {
                            reportSelectionDialog.open();
                        }
                    }
                }
                Column {
                    width: parent.width
                    spacing: platformStyle.paddingSmall
                    Label {
                        text: qsTr("Popis (nepovinne)");
                        platformInverted: window.platformInverted
                    }
                    TextField {
                        width: parent.width
                        platformInverted: window.platformInverted
                    }
                }
            }
        }
        onAccepted: {
            console.log("nahlasit")
        }
    }
}
