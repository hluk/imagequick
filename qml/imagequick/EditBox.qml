// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    color: "white"
    width: 320
    height: edit.height+10
    anchors.centerIn: parent
    radius: 6
    border.color: "black"
    border.width: 2
    smooth: true
    opacity: 0

    signal changed(string text)
    signal accepted(string text)
    signal rejected()
    signal closed()

    property alias text: edit.text
    property alias label: editlabel.text

    function close() {
        opacity = 0;
        focus = false;
        parent.focus = true;
        closed();
    }

    function show() {
        opacity = 1;
        edit.focus = true;
        edit.selectAll();
    }

    function accept() {
        if (timer.running) {
            changed(text);
            timer.stop();
        }
        accepted(text);
        close();
    }

    function reject() {
        if (timer.running) {
            changed(text);
            timer.stop();
        }
        rejected();
        close();
        edit.text = "";
    }

    function copyAll() {
        edit.selectAll();
        edit.copy();
    }

    Behavior on opacity {
        PropertyAnimation {
            duration: show_duration
            easing.type: Easing.InOutQuad;
        }
    }

    Text {
        id: editlabel
        anchors.left: parent.left
        anchors.margins: 10
        anchors.verticalCenter: parent.verticalCenter
        font {
            pixelSize: 16
        }
    }

    TextInput {
        id: edit

        anchors {
            left: editlabel.right
            right: parent.right
            leftMargin: 10
            rightMargin: 10
            verticalCenter: parent.verticalCenter
        }
        cursorVisible: true
        color: "#151515"
        selectionColor: "Green"

        font {
            pixelSize: 16
            bold: true
        }
        onTextChanged: {
            timer.running = true
        }
        Timer {
            id: timer
            interval: 500
            running: false
            repeat: false
            onTriggered: changed(text)
        }
    }

    Keys.forwardTo: [returnKey, edit]
    Item {
        id: returnKey
        Keys.onReturnPressed: accept()
        Keys.onEnterPressed:  accept()
        Keys.onEscapePressed: reject()
        Keys.onPressed: event.accepted = true
    }
}
