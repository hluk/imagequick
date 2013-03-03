# PREFIX=/usr/local  -- set install prefix
# STANDALONE=1       -- compile single binary
isEqual(STANDALONE,1) {
    # Compile application without any external images or QMLs.
    RESOURCES += resource.qrc
    DEFINES += IMAGEQUICK_STANDALONE
}
!isEqual(STANDALONE,1) {
    # Add more folders to ship with the application, here
    folder_qml.source = qml
    folder_images.source = images/imagequick.svg
    folder_images.target = images
    DEPLOYMENTFOLDERS = folder_qml folder_images
}

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

SOURCES += main.cpp

# Please do not modify the following two lines. Required for deployment.
include(qtquick2applicationviewer/qtquick2applicationviewer.pri)

# Install -- qmake PREFIX=/usr/local
!isEmpty(PREFIX) {
    unix:!macx {

        target.path = $$PREFIX/bin
        DEFINES += INSTALL_PREFIX=$$PREFIX

        !isEqual(STANDALONE,1) {
            INSTALL_DATA_PATH = share/imagequick
            INSTALL_ICON_PATH = share/icons/hicolor/scalable/apps

            folder_qml.target = ../$$INSTALL_DATA_PATH
            folder_images.target = ../$$INSTALL_ICON_PATH

            DEFINES += INSTALL_DATA_PATH=$$INSTALL_DATA_PATH
            DEFINES += INSTALL_ICON_PATH=$$INSTALL_ICON_PATH
        }
    }
}

qtcAddDeployment()
