import QtQuick 1.1

Popup {
    color: "white"
    width: 320
    height: edit.height+10

    signal changed(string text)
    signal accepted(string text)
    signal rejected()

    property alias text: edit.text
    property alias label: editlabel.text

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

    Text {
        id: editlabel
        color: "#444"
        anchors.left: parent.left
        anchors.margins: 10
        anchors.verticalCenter: parent.verticalCenter
        font {
            pixelSize: 16
            bold: true
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

    onShown: {
        edit.focus = true;
        edit.selectAll();
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
