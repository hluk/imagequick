import QtQuick 1.1
import "Storage.js" as Storage

Rectangle {
    id: page
    width: 360
    height: 360
    color: "black"
    focus: true

    property bool horizontal: false
    property string filter: ""
    property string single: filename
    property bool one: filename !== ""

    /* colors */
    property color colorCurrent: "yellow"
    property color colorImage: "white"
    property color colorDirectory: "#9df"
    property color colorOther: "gray"

    /* animation properties */
    property int scrollDuration: 100
    property int zoomDuration: 250
    property int showDuration: 300

    property int scrollAmount: 200

    function quit() {
        Qt.quit();
    }

    function restoreSession() {
        var path, val, db;

        if (!session) {
            view.setSource(src);
            return;
        };

        db = Storage.getDatabase(session);

        path = Storage.getSetting(db, "path");
        view.setSource(src || path || currentPath);

        val = parseInt( Storage.getSetting(db, "current") );
        if (val >= 0)
            view.select(val);

        val = Storage.getSetting(db, "horizontal");
        if (val)
            horizontal = val !== "false";

        val = parseFloat(Storage.getSetting(db, "zoom"));
        if (val)
            view.zoom = val;

        val = Storage.getSetting(db, "filter");
        if (val !== undefined)
            filter = val;

        val = Storage.getSetting(db, "state");
        if (val !== undefined)
            view.state = val;

        val = Storage.getSetting(db, "one");
        if (val)
            one = val === "true";

        val = parseFloat(Storage.getSetting(db, "sharpen"));
        if (val)
            view.sharpenStrength = val;

        val = Storage.getSetting(db, "history");
        if (val)
            view.setHistory(val.split(","));
    }

    function saveSession() {
        var d, db;

        if (!session) return;

        d = {};
        d["current"] = view.current();
        d["path"] = view.source();
        d["last-access"] = new Date().toISOString();
        d["horizontal"] = horizontal;
        d["state"] = view.state;
        d["one"] = view.one;
        d["zoom"] = view.zoom;
        d["filter"] = filter;
        d["sharpen"] = view.sharpenStrength;
        d["history"] = String(view.getHistory());

        db = Storage.getDatabase(session);
        Storage.initialize(db);
        Storage.setSettings(db, d);
    }

    function search() {
        searchEdit.show();
    }

    function isMatched(fileName, filter) {
        return fileName.toLowerCase().indexOf(filter) !== -1;
    }

    function showHelp() {
        helpPopup.show();
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
    EditBox {
        id: searchEdit
        text: filter
        label: "Filter:"
        onChanged: {
            filter = text.toLowerCase();
        }
        onAccepted: {
            filter = text.toLowerCase();
            if (view.currentItem.isHidden) {
                view.next();
                if (view.currentItem.isHidden)
                    view.previous();
            }
        }
        onRejected: {
            filter = "";
        }
    }

    /* url edit box */
    EditBox {
        id: urlEdit
        label: "URL:"
        onAccepted: {
            view.goTo(text);
        }
    }

    /* search box */
    Help {
        id: helpPopup
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

        if (k === Qt.Key_A) {
            view.sharpenStrength = Math.min(1.0, view.sharpenStrength + 0.05);
        } else if (k === Qt.Key_Z) {
            view.sharpenStrength = Math.max(0.0, view.sharpenStrength - 0.05);
        } else if (ctrl && (k === Qt.Key_D || k === Qt.Key_L)) {
            urlEdit.text = view.currentItem.path(true);
            urlEdit.show();
        } else if ( k === Qt.Key_Apostrophe || (ctrl && k === Qt.Key_F) ) {
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
        } else if ( (ctrl && k === Qt.Key_R) || k === Qt.Key_F5 ) {
            view.reload();
        } else if (k === Qt.Key_W) {
            view.zoom = 1.0;
            view.state = "FIT-TO-WIDTH";
        } else if (k === Qt.Key_Enter || k === Qt.Key_Return) {
            view.forward()
        } else if (k === Qt.Key_Right) {
            view.scroll(scrollAmount, 0)
        } else if (k === Qt.Key_Left) {
            view.scroll(-scrollAmount, 0)
        } else if (k === Qt.Key_Up) {
            view.scroll(0, -scrollAmount)
        } else if (k === Qt.Key_Down) {
            view.scroll(0, scrollAmount)
        } else if (k === Qt.Key_Home) {
            view.select(0);
            view.positionViewAtBeginning()
        } else if (k === Qt.Key_End) {
            view.select(view.count-1);
            view.positionViewAtEnd()
        } else if (k === Qt.Key_PageDown) {
            view.scroll(0, view.height-scrollAmount)
        } else if (k === Qt.Key_PageUp) {
            view.scroll(0, -view.height+scrollAmount)
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
        } else if (k === Qt.Key_Question || k === Qt.Key_F1) {
            showHelp();
        } else {
            event.accepted = false;
        }
    }
}
