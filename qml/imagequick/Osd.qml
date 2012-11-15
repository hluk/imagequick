import QtQuick 1.1

Text {
    id: osd
    anchors.margins: 6
    color: "white"
    style: Text.Outline
    styleColor: "black"
    opacity: 0

    font {
        pixelSize: 16
        bold: true
    }

    Behavior on text {
        SequentialAnimation {
            running: false
            NumberAnimation {
                target: osd
                property: "opacity"
                to: 0.7
                duration: 500
            }
            NumberAnimation {
                target: osd
                property: "opacity"
                to: 0.0
                duration: 6000
                easing.type: Easing.InQuint
            }
        }
    }
}
