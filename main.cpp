#include <QDir>
#include <QFile>
#include <QGuiApplication>
#include <QIcon>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <iostream>

#define VERSION "0.2.0"

using std::endl;

void printHelp(const char *cmd)
{
    std::cout << "Usage:" << endl
              << "  " << cmd << " [filename|directory|url]" << endl
              << "    Opens image or directory or images in Atom/RSS feed." << endl
              << "  " << cmd << " -S<session> [filename|directory|url]" << endl
              << "    Restores/saves session <session>." << endl
              << endl
              << "ImageQuick v" VERSION << " (hluk@email.cz)" << endl;
}

int main(int argc, char *argv[])
{
    // Create Qt GUI application.
    QGuiApplication app(argc, argv);

    // Parse command line arguments.
    QString src;
    QString session;
    QString filename;
    bool sessionNext = false;
    bool filenameNext = false;

    for ( const auto &arg : QGuiApplication::arguments().mid(1) ) {
        if ( sessionNext ) {
            session = arg;
            sessionNext = false;
            filenameNext = true;
        } else if ( !filenameNext && session.isEmpty() && arg.startsWith("-s", Qt::CaseInsensitive) ) {
            if (arg.length() == 2)
                sessionNext = true;
            else
                session = arg.right( arg.length()-2 );
            filenameNext = true;
        } else if ( !filenameNext && (arg == QString("-") || arg == QString("--")) ) {
            filenameNext = true;
        } else if ( !filenameNext && (arg == QString("-h") || arg == QString("--help")) ) {
            printHelp(argv[0]);
            return 0;
        } else if ( src.isEmpty() ) {
            src = arg;
        } else {
            printHelp(argv[0]);
            return 1;
        }
    }

    QQmlApplicationEngine engine;

    QQmlContext *context = engine.rootContext();

    // Browse URL from arguments or current directory.
    if ( src.isEmpty() ) {
        context->setContextProperty( "currentPath", "file://" + QDir::currentPath() );
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
    context->setContextProperty("src", src);
    context->setContextProperty("session", session);
    context->setContextProperty("filename", filename);

#if defined(IMAGEQUICK_STANDALONE)
    const QUrl mainQml("qrc:/qml/qml/main.qml");
    const QIcon icon(":/images/logo");
#elif defined(INSTALL_PREFIX)
    const QUrl mainQml(INSTALL_PREFIX "/" INSTALL_DATA_PATH "/qml/main.qml");
    const QIcon icon(INSTALL_PREFIX "/" INSTALL_ICON_PATH "/imagequick.svg");
#else
    const QString sharePath = QGuiApplication::applicationDirPath();
    const QUrl mainQml(sharePath + "/qml/main.qml");
    const QIcon icon(sharePath + "/images/imagequick.svg");
#endif

    engine.load(mainQml);
    app.setWindowIcon(icon);

    return app.exec();
}
