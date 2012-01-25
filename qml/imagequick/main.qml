import QtQuick 1.1
import "Storage.js" as Storage

Rectangle {
    id: page
    width: 360
    height: 360
    color: "black"
    focus: true

    property bool horizontal: true
    property string filter: ""

    /* colors */
    property color color_current: "yellow"
    property color color_image: "white"
    property color color_directory: "#9df"
    property color color_other: "gray"

    /* animation properties */
    property int scroll_duration: 100
    property int zoom_duration: 250
    property int show_duration: 300

    property int scroll_amount: 200

    function quit() {
        Qt.quit();
    }

    function restoreSession() {
        var current, path, val;

        path = Storage.getSetting(src+"-path");
        view.setDirectory(path || src);

        current = parseInt( Storage.getSetting(src+"-current") );
        if (current >= 0)
            view.select(current);

        val = Storage.getSetting(src+"-horizontal");
        horizontal = val !== "false";

        val = parseFloat(Storage.getSetting(src+"-zoom"));
        if (val)
            view.zoom = val;

        val = Storage.getSetting(src+"-filter");
        if (val !== undefined)
            filter = val;

        val = Storage.getSetting(src+"-state");
        if (val !== undefined)
            view.state = val;
    }

    function saveSession() {
        var date = new Date();
        Storage.initialize();
        Storage.setSetting(src+"-current", view.current());
        Storage.setSetting(src+"-path", view.model.folder);
        Storage.setSetting(src+"-last-access", date.toISOString());
        Storage.setSetting(src+"-horizontal", horizontal);
        Storage.setSetting(src+"-state", view.state);
        Storage.setSetting(src+"-zoom", view.zoom);
        Storage.setSetting(src+"-filter", filter);
    }

    function search() {
        search_edit.show();
    }

    function isMatched(fileName, filter) {
        return fileName.toLowerCase().indexOf(filter) !== -1;
    }

    /* main view */
    ImageView {
        id: view
        anchors.fill: parent

        /* restore session */
        Component.onCompleted: {
            restoreSession();
        }

        /* save session */
        Component.onDestruction: {
            saveSession();
        }
    }

    /* search box */
    Search {
        id: search_edit
        text: filter
        onSearch: {
            filter = text.toLowerCase();
        }
        onClosed: {
            if (view.currentItem.is_hidden) {
                view.next();
                if (view.currentItem.is_hidden)
                    view.previous();
            }
        }
    }

    /* keyboard */
    Keys.onBackPressed: {
        view.back();
        event.accepted = true;
    }
    Keys.onAsteriskPressed: {
        view.zoom = 1.0;
        view.state = "NORMAL";
        event.accepted = true;
    }
    Keys.onPressed: {
        var k, m, shift, ctrl;

        k = event.key;
        m = event.modifiers;
        shift = event.modifiers & Qt.ShiftModifier;
        ctrl  = event.modifiers & Qt.ControlModifier;

        event.accepted = true;

        if ( k === Qt.Key_Apostrophe || (ctrl && k === Qt.Key_F) ) {
            search();
        } else if (k === Qt.Key_H) {
            view.zoom = 1.0;
            view.state = "FIT-TO-HEIGHT";
        } else if ( (shift && k === Qt.Key_N) || k === Qt.Key_K || k === Qt.Key_B ) {
            view.previous()
        } else if (k === Qt.Key_J || k === Qt.Key_N) {
            view.next()
        } else if (k === Qt.Key_O) {
            horizontal = !horizontal
        } else if (k === Qt.Key_Q || k === Qt.Key_Escape) {
            quit();
        } else if (k === Qt.Key_W) {
            view.zoom = 1.0;
            view.state = "FIT-TO-WIDTH";
        } else if (k === Qt.Key_Enter || k === Qt.Key_Return) {
            view.forward()
        } else if (k === Qt.Key_Right) {
            view.scroll(scroll_amount, 0)
        } else if (k === Qt.Key_Left) {
            view.scroll(-scroll_amount, 0)
        } else if (k === Qt.Key_Up) {
            view.scroll(0, -scroll_amount)
        } else if (k === Qt.Key_Down) {
            view.scroll(0, scroll_amount)
        } else if (k === Qt.Key_Home) {
            view.select(0);
            view.positionViewAtBeginning()
        } else if (k === Qt.Key_End) {
            view.select(view.count-1);
            view.positionViewAtEnd()
        } else if (k === Qt.Key_PageDown) {
            view.scroll(0, view.height-scroll_amount)
        } else if (k === Qt.Key_PageUp) {
            view.scroll(0, -view.height+scroll_amount)
        } else if (k === Qt.Key_Space) {
            if (horizontal)
                view.scroll( (shift ? -1 : 1) * (view.width-100), 0 )
            else
                view.scroll( 0, (shift ? -1 : 1) * (view.height-100) )
        } else if (k === Qt.Key_Plus) {
            view.zoom += 0.125;
        } else if (k === Qt.Key_Minus) {
            view.zoom -= 0.125;
        } else if (k === Qt.Key_Period) {
            view.zoom = 1.0;
            view.state = "FILL";
        } else if (k === Qt.Key_Slash) {
            view.zoom = 1.0;
            view.state = "FIT";
        } else if (k === Qt.Key_Backspace) {
            view.back();
        } else {
            event.accepted = false;
        }
    }
}
