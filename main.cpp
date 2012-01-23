#include <QtGui/QApplication>
#include <QVariant>
#include <QDir>
#include <QDebug>
#include <QDeclarativeContext>
#include "qmlapplicationviewer.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    QmlApplicationViewer viewer;

    QVariant src( argc > 1 ? "file://" + QDir(argv[1]).absolutePath() : QDir::currentPath() );
    viewer.rootContext()->setContextProperty("src", src);

    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setSource(QUrl("qrc:/qml/qml/imagequick/main.qml"));
    //viewer.showExpanded();
    viewer.showFullScreen();

    return app->exec();
}
