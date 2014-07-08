TEMPLATE = app

QT += qml quick

CONFIG += c++11

SOURCES += main.cpp

# PREFIX=/usr/local  -- set install prefix
# STANDALONE=1       -- compile single binary
isEqual(STANDALONE,1) {
    # Compile application without any external images or QMLs.
    RESOURCES += resource.qrc
    DEFINES += IMAGEQUICK_STANDALONE
} else {
    # Add more folders to ship with the application, here
    folder_qml.files = qml
    folder_images.files = images/imagequick.svg
    folder_images.path = images
    INSTALLS = folder_qml folder_images
}

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Install -- qmake PREFIX=/usr/local
!isEmpty(PREFIX) {
    unix:!macx {
        target.path = $$PREFIX/bin
        DEFINES += INSTALL_PREFIX=\\\"$$PREFIX\\\"

        !isEqual(STANDALONE,1) {
            INSTALL_DATA_PATH = share/imagequick
            INSTALL_ICON_PATH = share/icons/hicolor/scalable/apps

            folder_qml.path = $$PREFIX/$$INSTALL_DATA_PATH
            folder_images.path = $$PREFIX/$$INSTALL_ICON_PATH
            desktop.files = imagequick.desktop
            desktop.path = $$PREFIX/share/applications

            INSTALLS += desktop

            DEFINES += INSTALL_DATA_PATH=\\\"$$INSTALL_DATA_PATH\\\"
            DEFINES += INSTALL_ICON_PATH=\\\"$$INSTALL_ICON_PATH\\\"
        }
    }
}

include(deployment.pri)
