// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

AnimatedImage {
    id: image
    source: ((is_hidden || is_directory()) && status !== Image.Ready) ? "" : path(one)
    anchors.centerIn: parent

    property real izoom: 1.0

    width:  implicitWidth  * izoom * zoom
    height: implicitHeight * izoom * zoom
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
