import QtQuick 1.1
import com.nokia.symbian 1.1
import "../js/utils.js" as Util
import "../js/theme.js" as Theme
import "../components"
import "../delegates"

Page {
    id: mainPage

    ListModel {
        id: categoriesModel
        Component.onCompleted: {
            categoriesModel.append({"category_id": -4,
                                       "category_name": "Náhodný vtip",
                                       "category_created": 0,
                                       "category_edited": 0
                                   });
            categoriesModel.append({"category_id": -3,
                                       "category_name": "Najnovšie vtipy",
                                       "category_created": 0,
                                       "category_edited": 0
                                   });
            categoriesModel.append({"category_id": -2,
                                       "category_name": "Najlepšie hodnotené",
                                       "category_created": 0,
                                       "category_edited": 0
                                   });
            categoriesModel.append({"category_id": -1,
                                       "category_name": "Tvoje obľúbené",
                                       "category_created": 0,
                                       "category_edited": 0
                                   });
            Util.getCategories(categoriesModel);
        }
    }

    AppHeader {
        id: header
    }

    function getCategoryJokesCount (category_id) {
        switch(category_id)
        {
        case -4:
            return 1;
        case -3:
            return Util.getNewestJokesCount();
        case -2:
            return Util.getBestJokesCount();
        case -1:
            return Util.getFavoriteJokesCount();
        default:
            return Util.getCategoryJokesCount(category_id);
        }
    }

    ListView {
        id: listview
        anchors.top: header.bottom
        anchors.bottom: toolbar.top
        width: parent.width
        clip: true
        model: categoriesModel
        cacheBuffer: count * Theme.listHeight
        delegate:  CategoryListDelegate {
            id: delegate
            title: model.category_name
            arrowVisible: index < 4 && categoryNumber == 0 ? false : true
            categoryNumber: getCategoryJokesCount(model.category_id);
            subtitle: "(" +  categoryNumber + ")";

            Connections {
                target: window
                ignoreUnknownSignals: true
                onDataSynchronized: {
                    delegate.categoryNumber = getCategoryJokesCount(model.category_id);
                }
                onFavoriteListUpdated: {
                    delegate.categoryNumber = getCategoryJokesCount(model.category_id);
                }
            }

            onClicked: {
                var page = "";
                if (delegate.categoryNumber > 0) {
                    page = window.pageStack.push(Qt.resolvedUrl("JokePage.qml"));
                    page.category_id = model.category_id
                } else if (delegate.categoryNumber == 0 && index > 3) {
                    page = window.pageStack.push(Qt.resolvedUrl("AddJokePage.qml"));
                    page.category = model.category_id
                }
            }
        }
    }

    ScrollBar {
        flickableItem: listview
        interactive: true
        anchors { right: listview.right; top: listview.top }
        platformInverted: window.platformInverted
    }

    AppToolBar {
        id: toolbar
        ImageButton {
            iconSource: "toolbar/btn_exit"
            anchors.left: parent.left
            onClicked: {
                Qt.quit()
            }
        }
        ImageButton {
            iconSource: "toolbar/btn_refresh"
            anchors.centerIn: parent
            onClicked: {
                window.update();
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
                    window.pageStack.push(Qt.resolvedUrl("AddJokePage.qml"));
                }
            }
            MenuItem {
                text: "Synchronizovať";
                platformInverted: window.platformInverted
                onClicked: {
                    window.update();
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
                text: "Koniec";
                platformInverted: window.platformInverted
                onClicked: {
                    Qt.quit()
                }
            }
        }
    }
}
