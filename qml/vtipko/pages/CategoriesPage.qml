import QtQuick 1.1
import com.nokia.symbian 1.1
import "../js/utils.js" as Util
import "../components"
import "../delegates"

Page {
    id: mainPage

    ListModel {
        id: categoriesModel
        Component.onCompleted: {
            Util.getCategories(categoriesModel);
        }
    }

    AppHeader {
        id: header
    }

    ListView {
        id: listview
        anchors.top: header.bottom
        anchors.bottom: toolbar.top
        width: parent.width
        clip: true
        model: categoriesModel
        cacheBuffer: count * Util.listHeight
        delegate:  CategoryListDelegate {
            id: delegate
            title: model.category_name
            property int categoryNumber: Util.getCategoryJokesCount(model.category_id);
            Component.onCompleted: {
                if (categoryNumber > 0)
                    delegate.height = Util.listHeight
            }

            subtitle: "(" +  categoryNumber + ")";

            Connections {
                target: window
                ignoreUnknownSignals: true
                onDataSynchronized: {
                    delegate.subtitle = "(" +  categoryNumber + ")";
                }
            }

            onClicked: {
                if (delegate.categoryNumber > 0) {
                    var page = window.pageStack.push(Qt.resolvedUrl("JokePage.qml"));
                    page.category_id = model.category_id
                }
            }
        }
    }

    ScrollBar {
        flickableItem: listview
        interactive: true
        anchors { right: listview.right; top: listview.top }
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
                Util.synchronize(window);
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
                text: qsTr("Synchronizovat");
                platformInverted: window.platformInverted
                onClicked: {
                    Util.synchronize(window);
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
                text: qsTr("Nastavenia");
                platformInverted: window.platformInverted
                onClicked: {
                    console.log("TODO");
                }
            }
            MenuItem {
                text: qsTr("Koniec");
                platformInverted: window.platformInverted
                onClicked: {
                    Qt.quit()
                }
            }
        }
    }
}
