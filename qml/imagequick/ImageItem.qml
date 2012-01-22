// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    id: item
    visible: !hidden

    property string path: filePath
    property bool hidden: !isMatched(fileName, filter)
    property bool loaded: image.status === Image.Ready

    width:  hidden ? 0 : (one || !horizontal) ?
                Math.max(view.width, image.width, label.width) :
                Math.max(image.width, label.width)
    height: hidden ? 0 : (one || horizontal) ?
                Math.max(view.height, image.height, label.height) :
                Math.max(image.height, label.height)

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

    Image {
        id: image
        source: hidden ? "" : filePath
        anchors.centerIn: parent

        property real izoom: 1.0

        width:  image.status === Image.Ready ?
                    (implicitWidth * izoom * zoom) :
                    0
        height: image.status === Image.Ready ?
                    (implicitHeight * izoom * zoom) :
                    0
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
