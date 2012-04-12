import QtQuick 1.1
import com.nokia.symbian 1.1
import com.nokia.extras 1.1
import "../js/utils.js" as Util
import "../js/theme.js" as Theme
import "../components"

Page {
    id: mainPage
    property int category_id;
    property string xhr_type: "rate"

    onCategory_idChanged: {
        switch(category_id)
        {
        case -4:
            Util.getRandomJoke(categoryJokesModel)
            break;
        case -3:
            Util.getNewestJokes(categoryJokesModel)
            break;
        case -2:
            Util.getBestJokes(categoryJokesModel);
            break;
        case -1:
            Util.getFavoriteJokes(categoryJokesModel);
            break;
        default:
            Util.getCategoryJokes(category_id, categoryJokesModel);
            break;
        }
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
        anchors.bottomMargin: Theme.paddingMedium
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
                height: column.height + 36 + 2 * Theme.paddingMedium
                anchors.horizontalCenter: parent.horizontalCenter
                source: Util.getImageFolder(false) + "common/title_bg.png"
                border {
                    left: 2 * Theme.paddingLarge
                    right: 2* Theme.paddingLarge
                    top: 2 * Theme.paddingLarge
                    bottom: 2 * Theme.paddingLarge
                }

                Image {
                    id: jokeFavorite
                    anchors.left: parent.left
                    anchors.leftMargin: 18 + Theme.paddingSmall
                    anchors.top: parent.top
                    anchors.topMargin: 18 + Theme.paddingMedium
                    source: Util.getImageFolder(false) + "common/faves_0.png"
                    property bool isFavorite: Util.isJokeFavorite(model.joke_id)
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            header.loading = true;
                            var text = "";
                            if (jokeFavorite.isFavorite) {
                                var removed = Util.removeJokeFromFavorites(model.joke_id);
                                jokeFavorite.isFavorite = !removed;
                                if (removed)
                                    text = "Vtip už nie je tvoj obľúbený."
                            } else {
                                var added = Util.addJokeToFavorites(model.joke_id);
                                jokeFavorite.isFavorite = added;
                                if (added)
                                    text = "Vtip je odteraz tvoj obľúbený."
                            }

                            if (text != "")
                                window.openNotification(text, true, true);

                            window.favoriteListUpdated();

                            mainPage.setCustom(jokeFavorite.isFavorite, jokeRating.ratingValue, "");
                        }
                    }
                    states: [
                        State {
                            name: "favorite"
                            when: jokeFavorite.isFavorite
                            PropertyChanges {
                                target: jokeFavorite
                                source: Util.getImageFolder(false) + "common/faves_1.png"
                            }
                        }
                    ]
                }

                Column {
                    id: column
                    anchors.left: jokeFavorite.right
                    anchors.leftMargin: Theme.paddingMedium
                    anchors.right: parent.right
                    anchors.rightMargin: 18 + Theme.paddingMedium
                    anchors.top: parent.top
                    anchors.topMargin: 18 + Theme.paddingMedium

                    Label {
                        text: model.joke_name
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        width: parent.width
                        color: Theme.fontColorBlue
                    }

                    Item {
                        width: parent.width
                        height: childrenRect.height

                        Label {
                            text: Util.getCategoryNameById(model.joke_category_id);
                            font.pixelSize: Theme.fontSizeSmall
                            anchors.left: parent.left
                            anchors.right: jokeNumberText.left
                            anchors.rightMargin: Theme.paddingMedium
                            elide: Text.ElideRight
                            color: Theme.fontColorGray
                        }

                        Label {
                            id: jokeNumberText
                            text: (delegate.ListView.view.currentIndex + 1) + " / " + categoryJokesModel.count
                            font.pixelSize: Theme.fontSizeSmall
                            anchors.right: parent.right
                            color: Theme.fontColorGray
                        }
                    }
                }
            }

            BorderImage {
                id: jokeTextBg
                anchors.top: jokeHeaderBg.bottom
                anchors.bottom: parent.bottom
                width: parent.width
                height: column.height + 72 + 2 * Theme.paddingMedium
                anchors.horizontalCenter: parent.horizontalCenter
                source: Util.getImageFolder(false) + "common/content_bg.png"
                border {
                    left: 2 * Theme.paddingLarge
                    right: 2* Theme.paddingLarge
                    top: 2 * Theme.paddingLarge
                    bottom: 2 * Theme.paddingLarge
                }

                Flickable {
                    id: jokeTextFlickable
                    anchors.left: parent.left
                    anchors.leftMargin: 18 + Theme.paddingMedium
                    anchors.right: parent.right
                    anchors.rightMargin: 18 + Theme.paddingMedium
                    anchors.top: parent.top
                    anchors.topMargin: 18 + Theme.paddingMedium
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 56 + Theme.paddingMedium
                    contentHeight: jokeText.height
                    clip: true

                    Label {
                        id: jokeText
                        width: parent.width

                        text: Util.stripslashes(model.joke_text);
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        color: Theme.fontColorGray
                    }
                }

                AppRatingIndicator {
                    id: jokeRating
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 18
                    anchors.right: parent.right
                    anchors.rightMargin: 18 + Theme.paddingMedium
                    maximumValue: 5
                    ratingValue: model.joke_rating / 100
                    onClicked: {
                        header.loading = true;
                        if (index == 0 && ratingValue == 1)
                            ratingValue = 0
                        else
                            ratingValue = index + 1;
                        var text = "Tvoje hodnotenie bolo odoslané.";
                        setCustom(jokeFavorite.isFavorite, ratingValue, text);
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

    function setCustom(favorite, rating, text) {
        var params = new Object;
        var url = "http://www.vtipko.eu/api/customdata";
        params.sign = "test";
        params.device = window.deviceinfo.imei;
        params.data_id = listview.model.get(listview.currentIndex).joke_id;
        params.custom_favorite = favorite ? 1 : 0
        params.custom_rating  = rating * 100;
        Util.xhrGet(url, params, text, mainPage.xhr_type, window);
    }

    Connections {
        target: window
        ignoreUnknownSignals: true
        onXhrSuccess: {
            if (success && text == mainPage.xhr_type) {
                header.loading = false;
            } else if (!success && text == mainPage.xhr_type) {
                header.loading = false;
            }
        }
    }

    Item {
        id: footer
        width: parent.width - 2 * Theme.paddingMedium
        height: Math.max(shareBtn.height, previousBtn.height)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: toolbar.top
        anchors.bottomMargin: Theme.paddingMedium

        ImageButton {
            id: previousBtn
            anchors.left: parent.left
            anchors.leftMargin: Theme.paddingMedium
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
            text: "Zdielať";
            onClicked: {
                shareMenu.open();
            }
        }

        ImageButton {
            id: nextBtn
            anchors.right: parent.right
            anchors.rightMargin: Theme.paddingMedium
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
                var page = window.pageStack.push(Qt.resolvedUrl("AddJokePage.qml"));
                page.category = listview.model.get(listview.currentIndex).joke_category_id
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
                text: "Pridať vtip";
                platformInverted: window.platformInverted
                onClicked: {
                    var page = window.pageStack.push(Qt.resolvedUrl("AddJokePage.qml"));
                    page.category = listview.model.get(listview.currentIndex).joke_category_id
                }
            }
            MenuItem {
                text: "Nahlás";
                platformInverted: window.platformInverted
                onClicked: {
                    var page = window.pageStack.push(Qt.resolvedUrl("ReportJokePage.qml"));
                    page.joke_id = listview.model.get(listview.currentIndex).joke_id
                }
            }
            MenuItem {
                text: "O vtipkovi";
                platformInverted: window.platformInverted
                onClicked: {
                    window.pageStack.push(Qt.resolvedUrl("AboutPage.qml"));
                }
            }
            MenuItem {
                text: "Návrat";
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
                text: "Facebook";
                platformInverted: window.platformInverted
                onClicked: {
                    var shareUrl = getShareUrl();
                    shareUrl = encodeURIComponent(shareUrl);
                    var page = window.pageStack.push(Qt.resolvedUrl("WebPage.qml"));
                    page.url = "http://m.facebook.com/sharer.php?u=" + shareUrl;
                }
            }
            MenuItem {
                text: "Twitter";
                platformInverted: window.platformInverted
                onClicked: {
                    var shareUrl = "http://twitter.com/home?status=" + getShareUrl();
                    //var page = window.pageStack.push(Qt.resolvedUrl("WebPage.qml"));
                    //page.url = shareUrl;
                    Qt.openUrlExternally(shareUrl)
                }
            }
            MenuItem {
                text: "SMS";
                platformInverted: window.platformInverted
                onClicked: {
                    Qt.openUrlExternally("sms:" + "?body=" + getShareUrl())
                }
            }
            MenuItem {
                text: "E-mail";
                platformInverted: window.platformInverted
                onClicked: {
                    Qt.openUrlExternally("mailto:" + "?subject=" + listview.model.get(listview.currentIndex).joke_name + "&body=" + listview.model.get(listview.currentIndex).joke_text + "\n" + getShareUrl())
                }
            }
        }
    }

    function getShareUrl() {
        var shareUrl = "http://www.vtipko.eu/vtip/" + listview.model.get(listview.currentIndex).joke_id
        return shareUrl;
    }

    MouseArea {
        anchors.fill: parent
        enabled: header.loading
    }
}
