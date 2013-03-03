#include "qtquick2applicationviewer.h"

#include <QtGui/QGuiApplication>
#include <QDir>
#include <QFile>
#include <QIcon>
#include <QQmlContext>
#include <iostream>

#define VERSION "0.1.0"

#define strx(x) #x
#define str(x) strx(x)

using std::endl;

static void printHelp(const char *cmd)
{
    std::cout << "Usage:" << endl
              << "  " << cmd << " [filename|directory|url]" << endl
              << "    Opens image or directory or images in Atom/RSS feed." << endl
              << "  " << cmd << " -S<session> [filename|directory|url]" << endl
              << "    Restores/saves session <session>." << endl
              << endl
              << "ImageQuick v" VERSION << " (hluk@email.cz)" << endl;
}

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    // Create Qt GUI application.
    QGuiApplication app(argc, argv);

    // Parse command line arguments.
    QString src, session, filename;
    bool sessionNext = false, filenameNext = false;
    QStringList args = QGuiApplication::arguments();
    for(int i = 1; i < args.length(); ++i) {
        const QString &arg = args.at(i);
        if ( sessionNext ) {
            session = arg;
            sessionNext = false;
            filenameNext = true;
        } else if ( !filenameNext && session.isEmpty() && arg.startsWith("-s", Qt::CaseInsensitive) ) {
            if (arg.length() == 2)
                sessionNext = true;
            else {
                session = arg.right( arg.length()-2 );
            }
            filenameNext = true;
        } else if ( !filenameNext &&
                    (arg == QString("-") || arg == QString("--")) ) {
            filenameNext = true;
        } else if ( !filenameNext &&
                    (arg == QString("-h") || arg == QString("--help")) ) {
            printHelp(argv[0]);
            return 0;
        } else if ( src.isEmpty() ) {
            src = arg;
        } else {
            printHelp(argv[0]);
            return 1;
        }
    }

    QtQuick2ApplicationViewer viewer;
    QQmlContext *content = viewer.rootContext();

    // Make viewer available to QML (to toggle fullscreen).
    content->setContextProperty("viewer", &viewer);

    // Browse URL from arguments or current directory.
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

    // Set up properties.
    content->setContextProperty("src", src);
    content->setContextProperty("session", session);
    content->setContextProperty("filename", filename);

    // Set up viewer.
    viewer.resize(360, 360);
    viewer.show();
#if defined(IMAGEQUICK_STANDALONE)
    viewer.setSource(QUrl("qrc:/qml/qml/main.qml"));
    // FIXME: This doesn't seem to work.
    viewer.setIcon(QIcon(":logo"));
#elif defined(INSTALL_PREFIX)
    viewer.setSource(QUrl(str(INSTALL_PREFIX) "/" str(INSTALL_DATA_PATH) "/qml/main.qml"));
    viewer.setIcon(QIcon(str(INSTALL_PREFIX) "/" str(INSTALL_ICON_PATH) "/imagequick.svg"));
#else
    const QString sharePath = QGuiApplication::applicationDirPath();
    viewer.setSource(QUrl(sharePath + "/qml/main.qml"));
    viewer.setIcon(QIcon(sharePath + "/images/imagequick.svg"));
#endif

    return app.exec();
}
