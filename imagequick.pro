equals(STANDALONE,1) {
    # Compile application without any external images or QMLs.
    RESOURCES += resource.qrc
    DEFINES += IMAGEQUICK_STANDALONE
}
!equals(STANDALONE,1) {
    # Add more folders to ship with the application, here
    folder_01.source = qml/imagequick
    folder_01.target = qml
    folder_02.source = images/logo.svg
    folder_02.target = images
    DEPLOYMENTFOLDERS = folder_01 folder_02
}

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

QT += opengl

SOURCES += main.cpp

# Please do not modify the following two lines. Required for deployment.
include(qtquick2applicationviewer/qtquick2applicationviewer.pri)
qtcAddDeployment()
