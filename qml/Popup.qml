import QtQuick 2.2

Rectangle {
    anchors.centerIn: parent
    color: "#ddd"
    border.color: "#333"
    border.width: 2
    radius: 6
    smooth: true
    opacity: 0

    property real popupOpacity: 1

    signal shown()
    signal closed()

    function show() {
        opacity = popupOpacity;
        focus = true;
        shown();
    }

    function close() {
        opacity = 0;
        focus = false;
        parent.focus = true;
        closed();
    }

    Behavior on opacity {
        PropertyAnimation {
            duration: page.showDuration
            easing.type: Easing.InOutQuad;
        }
    }
}
