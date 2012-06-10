#include <QtGui/QApplication>
#include <QVariant>
#include <QDir>
#include <QFile>
#include <QDeclarativeContext>
#include <QGLWidget>
#include <iostream>
#include "qmlapplicationviewer.h"

static void print_help(const char *cmd)
{
    std::cout << "Usage:" << std::endl
              << cmd << " [filename|directory|url]" << std::endl
              << "  Opens image or directory or images in Atom/RSS feed." << std::endl
              << cmd << " -S<session_name> [filename|directory|url]" << std::endl
              << "  Restores/saves session <session_name>." << std::endl;
}

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    QmlApplicationViewer viewer;
    QDeclarativeContext *content = viewer.rootContext();

    /* OpenGL viewport */
    viewer.setViewport(new QGLWidget);
    viewer.setViewportUpdateMode(QGraphicsView::FullViewportUpdate);

    /* get arguments */
    QString src, session, filename;
    bool session_next = false, filename_next = false;
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
        } else if ( !filename_next &&
                    (arg == QString("-h") || arg == QString("--help")) ) {
            print_help(argv[0]);
            return 0;
        } else if ( src.isEmpty() ) {
            src = arg;
        } else {
            print_help(argv[0]);
            return 1;
        }
    }

    if ( src.isEmpty() ) {
        content->setContextProperty( "currentPath", "file://" + QDir::currentPath() );
    } else {
        if ( QFile::exists(src) ) {
            QDir dir(src);
            if ( !dir.exists() ) {
                filename = dir.dirName();
                dir.cdUp();
            }
            src = "file://" + dir.absolutePath();
        }
    }

    content->setContextProperty("src", src);
    content->setContextProperty("session", session);
    content->setContextProperty("filename", filename);

    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setSource(QUrl("qrc:/qml/qml/imagequick/main.qml"));
    viewer.showFullScreen();

    return app->exec();
}
