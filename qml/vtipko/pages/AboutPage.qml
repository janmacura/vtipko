import QtQuick 1.1
import com.nokia.symbian 1.1
import "../components"
import "../delegates"
import "../js/utils.js" as Util

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
        }

        ListElement {
            icon: "common/google.png"
            text: "Vtipko aj na Google+"
            url: "http://www.google.com/vtipko"
        }

        ListElement {
            icon: "common/ovi.png"
            text: "Ohodnot aplikaciu v Nokia Ovi Store"
            url: "http://store.ovi.com/"
        }

        ListElement {
            icon: "common/paypal.png"
            text: "Podpor nasu pracu"
            url: "http://paypal.com/"
        }
    }

    ListModel {
        id: model2

        ListElement {
            title: "Programovanie: "
            text: "Jan Macura"
            url: "mailto:janko.macura@gmail.com"
        }

        ListElement {
            title: "Design: "
            text: "Peter Bartos"
            url: "mailto:hrochodyl@gmail.com"
        }

        ListElement {
            title: "Verzia: "
            text: "1.0.0"
            url: ""
        }

        ListElement {
            title: "2012 "
            text: "www.vtipko.eu"
            url: "http://www.vtipko.eu"
        }
    }

    Flickable {
        id: aboutFlickable
        anchors.top: header.bottom
        anchors.bottom: toolbar.top
        width: parent.width
        contentHeight: aboutColumn.height + 2 * platformStyle.paddingMedium
        clip: true

        Column {
            id: aboutColumn
            anchors.top: parent.top
            anchors.topMargin: platformStyle.paddingMedium
            width: parent.width - 2 * platformStyle.paddingMedium
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: platformStyle.paddingMedium

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
                height: model.count * 60
                model: model1
                interactive: false
                cacheBuffer: 1
                delegate: IconListDelegate {
                    iconPath: model.icon
                    text: model.text
                    url: model.url
                    height: 60
                }
            }

            ListView {
                width: parent.width
                model: model2
                interactive: false
                cacheBuffer: 1
                height: model.count * 30
                delegate: LabelListDelegate {
                    title: model.title
                    text: model.text
                    url: model.url
                    height: 30
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
