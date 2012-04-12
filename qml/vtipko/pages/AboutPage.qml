import QtQuick 1.1
import com.nokia.symbian 1.1
import "../components"
import "../delegates"
import "../js/utils.js" as Util
import "../js/theme.js" as Theme

Page {
    id: mainPage

    AppHeader {
        id: header
    }

    ListModel {
        id: model1
        ListElement {
            icon: "common/facebook.png"
            text: "Sleduj vtipy na Facebooku"
            url: "http://www.facebook.com/vtipko"
            type: "web"
        }

        ListElement {
            icon: "common/google.png"
            text: "Sleduj vtipy na Google+"
            url: "https://plus.google.com/112564593456422643689"
            type: "web"
        }

        ListElement {
            icon: "common/twitter.png"
            text: "Sleduj vtipy na Twitter"
            url: "http://www.twitter.com/vtipko"
            type: "web"
        }

        ListElement {
            icon: "common/ovi.png"
            text: "Ohodnoť aplikáciu v Ovi Store"
            url: "http://store.ovi.com/"
            type: "web"
        }
    }

    ListModel {
        id: model2

        ListElement {
            title: "Vtipko leader: "
            text: "Matúš Jančík"
            url: "http://www.originals.sk"
            type: "web"
        }

        ListElement {
            title: "Programovanie: "
            text: "Ján Macura"
            url: "mailto:janko.macura@gmail.com"
            type: "mail"
        }

        ListElement {
            title: "Design: "
            text: "Peter Bartoš"
            url: "http://www.hrochodyl.sk"
            type: "web"
        }

        ListElement {
            title: "Verzia: "
            text: "1.0.0"
            url: ""
            type: ""
        }

        ListElement {
            title: "© 2012 "
            text: "www.vtipko.eu"
            url: "http://www.vtipko.eu"
            type: "web"
        }
    }

    Flickable {
        id: aboutFlickable
        anchors.top: header.bottom
        anchors.bottom: toolbar.top
        width: parent.width
        contentHeight: aboutColumn.height + 2 * Theme.paddingMedium
        clip: true

        Column {
            id: aboutColumn
            anchors.top: parent.top
            anchors.topMargin: Theme.paddingMedium
            width: parent.width - 2 * Theme.paddingMedium
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: Theme.paddingMedium

            Image {
                id: name
                source: Util.getImageFolder(false) + "common/splash.png"
                smooth: true
                anchors.horizontalCenter: parent.horizontalCenter
                height: 100
                fillMode: Image.PreserveAspectFit
            }

            ListView {
                width: parent.width
                height: model.count * 45
                model: model1
                interactive: false
                cacheBuffer: 1
                delegate: IconListDelegate {
                    iconPath: model.icon
                    text: model.text
                    url: model.url
                    height: 45

                    onClicked: {
                        console.log(model.url);
                        Qt.openUrlExternally(model.url);
                    }
                }
            }

            ListView {
                width: parent.width
                model: model2
                interactive: false
                cacheBuffer: 1
                height: model.count * 35
                delegate: LabelListDelegate {
                    title: model.title
                    text: model.text
                    url: model.url
                    height: 35

                    onClicked: {
                        console.log(model.url);
                        Qt.openUrlExternally(model.url);
                        //                        if (model.type == "web") {
                        //                            var page = window.pageStack.push(Qt.resolvedUrl("WebPage.qml"));
                        //                            page.url = model.url
                        //                        } else {
                        //                            Qt.openUrlExternally(model.url);
                        //                        }
                    }
                }
            }
        }
    }

    ScrollBar {
        flickableItem: aboutFlickable
        interactive: true
        anchors { right: parent.right; top: aboutFlickable.top }
    }

    AppToolBar {
        id: toolbar
        BackButton {
            anchors.left: parent.left
        }
    }
}
