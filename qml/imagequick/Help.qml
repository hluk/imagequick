import QtQuick 1.1

Rectangle {
    width: help.width + 16
    height: help.height + 16
    anchors.centerIn: parent
    color: "#ddd"
    border.color: "#333"
    border.width: 2
    radius: 6
    smooth: true

    opacity: 0

    Column {
        id: help
        spacing: 6
        anchors.centerIn: parent

        HelpItem {
            label: qsTr("F1 ?")
            help: qsTr("This popup")
        }
        HelpItem {
            label: qsTr("Arrow Keys")
            help: qsTr("Navigation")
        }
        HelpItem {
            label: qsTr("Home End")
            help: qsTr("First/Last Item")
        }
        HelpItem {
            label: qsTr("Page Down/Up")
            help: qsTr("Next/Previous Page")
        }
        HelpItem {
            label: qsTr("Space")
            help: qsTr("Scroll Down")
        }
        HelpItem {
            label: qsTr("A Z")
            help: qsTr("Sharpen/Unsharpen")
        }
        HelpItem {
            label: qsTr("C")
            help: qsTr("Copy File Name")
        }
        HelpItem {
            label: qsTr("Ctrl+F '")
            help: qsTr("Filter Items")
        }
        HelpItem {
            label: qsTr("H W")
            help: qsTr("Fit to Height/Width")
        }
        HelpItem {
            label: qsTr("J N")
            help: qsTr("Next Item")
        }
        HelpItem {
            label: qsTr("K P B Shift+N")
            help: qsTr("Previous Item")
        }
        HelpItem {
            label: qsTr("O")
            help: qsTr("Horizontal/Vertical Layout")
        }
        HelpItem {
            label: qsTr("Escape Q")
            help: qsTr("Quit")
        }
        HelpItem {
            label: qsTr("Ctrl+R F5")
            help: qsTr("Reload")
        }
        HelpItem {
            label: qsTr("Enter")
            help: qsTr("Forward")
        }
        HelpItem {
            label: qsTr("Backspace")
            help: qsTr("Back")
        }
        HelpItem {
            label: qsTr("+ -")
            help: qsTr("Zoom In/Out")
        }
        HelpItem {
            label: qsTr(". /")
            help: qsTr("Zoom to Fill/Fit")
        }
    }

    function close() {
        opacity = 0;
        focus = false;
        parent.focus = true;
    }

    function show() {
        opacity = 0.9;
        focus = true;
    }

    Keys.onPressed: {
        // close on any key
        close();

        // propagate some keys to parent
        var k = event.key;
        if (k === Qt.Key_F1 || k === Qt.Key_Question || k === Qt.Key_Escape
            || k === Qt.Key_Enter || k === Qt.Key_Return) {
            event.accepted = true;
        }
    }
}
