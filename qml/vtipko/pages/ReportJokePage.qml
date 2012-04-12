import QtQuick 1.1
import com.nokia.symbian 1.1
import "../components"
import "../delegates"
import "../js/utils.js" as Util
import "../js/theme.js" as Theme

Page {
    id: mainPage

    property string joke_id: ""
    property string xhr_type: "report"

    AppHeader {
        id: header
    }

    SelectionDialog {
        id: reportSelectionDialog
        titleText: "Vyber možnosť";
        platformInverted: window.platformInverted
        selectedIndex: 0
        model: ListModel {
            ListElement { name: "Chyba vo vtipe"}
            ListElement { name: "Nevhodný vtip"}
            ListElement { name: "Spam"}
            ListElement { name: "Iné"}
        }
    }

    Column {
        id: columnDialog
        anchors.top: header.bottom
        anchors.topMargin: Theme.paddingMedium
        width: parent.width - 2 * Theme.paddingMedium
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: Theme.paddingMedium

        Column {
            width: parent.width
            spacing: Theme.paddingSmall
            Label {
                text: "Nahlás";
                platformInverted: window.platformInverted
            }
            Button {
                width: parent.width
                text: reportSelectionDialog.selectedIndex != -1 ? reportSelectionDialog.model.get(reportSelectionDialog.selectedIndex).name : "Vyber možnosť";
                platformInverted: window.platformInverted
                onClicked: {
                    reportSelectionDialog.open();
                }
            }
        }
        Column {
            width: parent.width
            spacing: Theme.paddingSmall
            Label {
                text: "Popis (nepovinné)";
                platformInverted: window.platformInverted
            }
            TextArea {
                id: reportTextField
                width: parent.width
                height: 160
            }
        }

        ImageButton {
            id: sendButton
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Nahlásiť vtip";
            onClicked: {
                header.loading = true;
                var params = new Object;
                var url = "http://www.vtipko.eu/api/datafeedback";
                params.sign = "test";
                params.data_id = mainPage.joke_id;
                params.device = window.deviceinfo.imei;
                params.type = reportSelectionDialog.selectedIndex != -1 ? reportSelectionDialog.model.get(reportSelectionDialog.selectedIndex).name : reportSelectionDialog.model.get(0).name
                params.text = reportTextField.text;
                var text = "Tvoj podnet bol odoslaný. Ďakujeme."
                Util.xhrGet(url, params, text, mainPage.xhr_type, window);
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

    AppToolBar {
        id: toolbar
        BackButton {
            anchors.left: parent.left
        }
    }
}
