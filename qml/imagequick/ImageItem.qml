// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    id: item

    property string path: filePath
    property string filename: fileName
    property bool is_directory: isDirectory(index >= 0 ? index : currentIndex)
    property bool is_image: image.status !== Image.Error
    property bool is_loaded: image.status === Image.Ready
    property bool is_current: ListView.isCurrentItem
    property bool is_hidden: !isMatched(filename, filter)

    opacity: is_hidden ? 0.0 : 1.0

    width:  opacity * ( (one || !horizontal) ?
                Math.max(view.width, image.width, label.width) :
                Math.max(image.width, label.width) )
    height: opacity * ( (one || horizontal) ?
                Math.max(view.height, image.height, label.height) :
                Math.max(image.height, label.height) )

    Behavior on opacity {
        NumberAnimation {
            duration: show_duration
            onCompleted: visible = is_hidden === 0.0
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            view.currentIndex = index
        }
        onDoubleClicked: {
            view.currentIndex = index
            forward()
        }
    }

    AnimatedImage {
        id: image
        source: (is_hidden || is_directory) ? "" : path
        anchors.centerIn: parent

        property real izoom: 1.0

        width:  is_loaded ? (implicitWidth  * izoom * zoom) : 0
        height: is_loaded ? (implicitHeight * izoom * zoom) : 0
        fillMode: Image.PreserveAspectFit
        smooth: true

        Behavior on izoom {
            NumberAnimation {
                duration: 250
                easing.type: Easing.OutQuad;
            }
        }

        /* ZOOM */
        states: [
            State {
                when: view.state === "NORMAL"
                PropertyChanges {
                    target: image
                    izoom: 1.0
                }
            },
            State {
                when: view.state === "FIT"
                PropertyChanges {
                    target: image
                    izoom: Math.min(1.0, view.width/implicitWidth,
                                         view.height/implicitHeight)
                }
            },
            State {
                when: view.state === "FILL"
                PropertyChanges {
                    target: image
                    izoom: Math.max(1.0, view.width/implicitWidth,
                                         view.height/implicitHeight)
                }
            },
            State {
                when: view.state === "FIT-TO-WIDTH"
                PropertyChanges {
                    target: image
                    izoom: Math.min(implicitWidth, view.width)/implicitWidth
                }
            },
            State {
                when: view.state === "FIT-TO-HEIGHT"
                PropertyChanges {
                    target: image
                    izoom: Math.min(implicitHeight, view.height)/implicitHeight
                }
            }
        ]
    }

    ImageLabel {
        id: label
    }
}
