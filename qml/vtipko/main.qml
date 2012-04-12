import QtQuick 1.1
import com.nokia.symbian 1.1
import QtMobility.systeminfo 1.1
import "js/utils.js" as Util
import "pages"

PageStackWindow {
    id: window
    showStatusBar: true
    showToolBar: false
    platformInverted: true

    SplashPage {
        id: splash
        z: 1000
    }

    property alias deviceinfo: info
    property int synctime: 0
    property bool synchronize: false;

    signal dataSynchronized();
    signal noNewDataAdded();
    signal favoriteListUpdated();
    signal xhrSuccess(string text, bool success);

    DeviceInfo {
        id: info
    }

    Component.onCompleted: {
        Util.createTables();

        if (Util.getCategoriesCount() == 0) {
            Util.loadCategoriesFromFile();
        }

        if (Util.getJokesCount() == 0) {
            Util.synchronize(window);
        } else {
            loadCategoriesPage()
        }
    }

    onDataSynchronized: {
        loadCategoriesPage();
    }

    onNoNewDataAdded: {
        loadCategoriesPage();
    }

    function loadCategoriesPage() {
        window.synchronize = true;
        if (window.pageStack.depth == 0)
            window.initialPage = Qt.resolvedUrl("pages/CategoriesPage.qml")
    }

    function update() {
        splash.text = "Chvíľku počkaj.\nNahrávam nové vtipy ..."
        splash.loaded = false;
        window.synchronize = false;
        splash.state = "visible";
        Util.synchronize(window);
    }

    function openNotification(text, success, timer) {
        if (success)
            notificationDialog.titleText = "Operácia prebehla úspešne";
        else
            notificationDialog.titleText = "Chyba";

        notificationDialog.notificationText = text
        notificationDialog.open();
        if (timer)
            dialogTimer.start();
    }

    CommonDialog {
        id: notificationDialog
        titleText: "Operácia prebehla úspešne";
        buttonTexts: ["Ok"]
        property string notificationText: "";
        platformInverted: window.platformInverted
        content: Label {
            anchors.top: parent.top
            anchors.topMargin: platformStyle.paddingMedium
            width: parent.width - 4 * platformStyle.paddingMedium
            anchors.horizontalCenter: parent.horizontalCenter
            text: notificationDialog.notificationText
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            platformInverted: window.platformInverted
        }
        Timer {
            id: dialogTimer
            interval: 1500; running: false; repeat: false
            onTriggered: notificationDialog.accept();
        }
    }
}
