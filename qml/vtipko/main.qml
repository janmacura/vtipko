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
        z: 1000
    }

    property alias deviceinfo: info
    property int synctime: 0
    property bool synchronize: false;

    signal dataSynchronized();

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
        loadCategoriesPage()
    }

    function loadCategoriesPage() {
        window.synchronize = true;
        if (window.pageStack.depth == 0)
            window.initialPage = Qt.resolvedUrl("pages/CategoriesPage.qml")
    }
}
