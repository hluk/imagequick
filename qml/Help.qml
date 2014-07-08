import QtQuick 2.2

Popup {
    width: help.width + 16
    height: help.height + 16
    popupOpacity: 0.9

    Column {
        id: help
        spacing: 2
        anchors.centerIn: parent

        HelpItem { label: qsTr("Navigation") }
        HelpItem {
            label: qsTr("Arrow Keys")
            help: qsTr("Movement")
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
            label: qsTr("J N")
            help: qsTr("Next Item")
        }
        HelpItem {
            label: qsTr("K P B Shift+N")
            help: qsTr("Previous Item")
        }
        HelpItem {
            label: qsTr("Ctrl+D Ctrl+L")
            help: qsTr("Go to URL")
        }

        HelpItem { label: qsTr("General") }
        HelpItem {
            label: qsTr("F1 ?")
            help: qsTr("Help")
        }
        HelpItem {
            label: qsTr("F")
            help: qsTr("Toggle Fullscreen")
        }
        HelpItem {
            label: qsTr("Ctrl+F '")
            help: qsTr("Filter Items")
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
            help: qsTr("Select")
        }
        HelpItem {
            label: qsTr("Backspace")
            help: qsTr("Back")
        }

        HelpItem { label: qsTr("Effects") }
        HelpItem {
            label: qsTr("+ -")
            help: qsTr("Zoom In/Out")
        }
        HelpItem {
            label: qsTr(". /")
            help: qsTr("Zoom to Fill/Fit")
        }
        HelpItem {
            label: qsTr("H W")
            help: qsTr("Fit to Height/Width")
        }
        HelpItem {
            label: qsTr("A Z")
            help: qsTr("Sharpen/Unsharpen")
        }
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
