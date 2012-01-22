// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: search_box
    color: "white"
    width: 320
    height: edit.height+10
    anchors.centerIn: parent
    radius: 6
    border.color: "black"
    border.width: 2
    smooth: true
    opacity: 0

    signal search(string text)
    signal closed()
    property alias text: edit.text

    function close() {
        opacity = 0;
        focus = false;
        parent.focus = true;
        closed();
    }

    function show() {
        opacity = 1;
        edit.focus = true;
    }

    Behavior on opacity {
        PropertyAnimation {
            duration: show_duration
            easing.type: Easing.InOutQuad;
        }
    }

    Text {
        id: label
        text: "Filter:"
        anchors.left: parent.left
        anchors.margins: 10
        anchors.verticalCenter: parent.verticalCenter
        font {
            pixelSize: 16
        }
    }

    TextInput {
        id: edit
        anchors.left: label.right
        anchors.right: parent.right
        anchors.margins: 10
        anchors.verticalCenter: parent.verticalCenter
        font {
            pixelSize: 16
        }
        onTextChanged: {
            timer.running = true
        }
        Timer {
            id: timer
            interval: 500
            running: false
            repeat: false
            onTriggered: search(text)
        }
    }

    Keys.onReturnPressed: {
        search(text);
        close();
        event.accepted = true;
    }
    Keys.onEnterPressed: {
        search(text);
        close();
        event.accepted = true;
    }
    Keys.onEscapePressed: {
        search("");
        close();
        event.accepted = true;
    }
}
