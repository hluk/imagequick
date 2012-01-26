#include <QtGui/QApplication>
#include <QVariant>
#include <QDir>
#include <QFile>
#include <QDeclarativeContext>
#include <iostream>
#include "qmlapplicationviewer.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    QmlApplicationViewer viewer;
    QDeclarativeContext *content = viewer.rootContext();

    /* get arguments */
    QString src, session, filename;
    bool session_next = false, filename_next = false, help = false;
    QStringList args = QApplication::arguments();
    for(int i = 1; i < args.length(); ++i) {
        const QString &arg = args.at(i);
        if ( session_next ) {
            session = arg;
            session_next = false;
            filename_next = true;
        } else if ( !filename_next && session.isEmpty() && arg.startsWith("-s", Qt::CaseInsensitive) ) {
            if (arg.length() == 2)
                session_next = true;
            else {
                session = arg.right( arg.length()-2 );
            }
            filename_next = true;
        } else if ( !filename_next &&
                    (arg == QString("-") || arg == QString("--")) ) {
            filename_next = true;
        } else if ( src.isEmpty() ) {
            src = arg;
        } else {
            help = true;
            break;
        }
    }

    if (help) {
        std::cout << "Usage:" << std::endl
                  << argv[0] << " [filename|directory|url]" << std::endl
                  << "  Opens image or directory or images in Atom/RSS feed." << std::endl
                  << argv[0] << " -S<session_name> [filename|directory|url]" << std::endl
                  << "  Restores/saves session <session_name>." << std::endl;
        return 1;
    }

    if ( src.isEmpty() ) {
        src = "file://" + QDir::currentPath();
    } else if ( QFile::exists(src) ) {
        QDir dir(src);
        if ( !dir.exists() ) {
            filename = dir.dirName();
            dir.cdUp();
        }
        src = "file://" + dir.absolutePath();
    }
    content->setContextProperty("src", src);
    content->setContextProperty("session", session);
    content->setContextProperty("filename", filename);

    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setSource(QUrl("qrc:/qml/qml/imagequick/main.qml"));
    viewer.showFullScreen();

    return app->exec();
}
