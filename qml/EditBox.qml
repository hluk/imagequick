import QtQuick 2.0

Popup {
    color: "white"
    width: row.width + 20
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

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 10

        Text {
            id: editlabel
            color: "#444"
            font {
                pixelSize: 16
                bold: true
            }
        }

        TextInput {
            id: edit
            cursorVisible: true
            color: "#151515"
            selectionColor: "Green"
            width: Math.max(100,
                            Math.min(implicitWidth, row.parent.parent.width - editlabel.width - 40))

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
