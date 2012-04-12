#include <QtGui/QApplication>
#include <QDir>
#include <QString>
#include <QDeclarativeEngine>
#include <QDebug>
#include "qmlapplicationviewer.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    QString customPath = "qml/OfflineStorage";

    QmlApplicationViewer viewer;

#ifdef Q_WS_SIMULATOR
    viewer.engine()->setOfflineStoragePath(QString(customPath));
#else
    QString privatePathQt(QApplication::applicationDirPath());
    qDebug() << privatePathQt;
    QString pathOfflineStorage(privatePathQt);
    pathOfflineStorage.append(QString("/" + customPath));
    qDebug() << pathOfflineStorage;
    pathOfflineStorage = QDir::toNativeSeparators(pathOfflineStorage);
    viewer.engine()->setOfflineStoragePath(pathOfflineStorage);
#endif

    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationLockPortrait);
    //viewer.setMainQmlFile(QLatin1String("qml/vtipko/main.qml"));
    viewer.setSource(QUrl("qrc:/qml/vtipko/main.qml"));
    viewer.showExpanded();

    return app->exec();
}
