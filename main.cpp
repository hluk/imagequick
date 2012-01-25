#include <QtGui/QApplication>
#include <QVariant>
#include <QDir>
#include <QDeclarativeContext>
#include "qmlapplicationviewer.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    QmlApplicationViewer viewer;

    /* set source path from arguments or current path */
    QVariant src;
    if (argc > 1) {
        QDir dir(argv[1]);
        if ( dir.exists() )
            src = "file://" + dir.absolutePath();
        else
            src = argv[1];
    } else {
        src = QDir::currentPath();
    }
    viewer.rootContext()->setContextProperty("src", src);

    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setSource(QUrl("qrc:/qml/qml/imagequick/main.qml"));
    //viewer.showExpanded();
    viewer.showFullScreen();

    return app->exec();
}
