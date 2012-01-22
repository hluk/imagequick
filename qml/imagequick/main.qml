import QtQuick 1.1

Rectangle {
    id: page
    width: 360
    height: 360
    color: "black"
    focus: true

    property string src: "/home/lukas/Pictures"
    property bool horizontal: true
    property string filter: ""
    property int scroll_duration: 100
    property int zoom_duration: 250
    property int show_duration: 300

    function toggle(dest, arg1, arg2) {
        dest = (dest === arg1) ? arg2 : arg1;
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
        width: page.width
        height: page.height
    }

    /* search box */
    Search {
        id: search_edit
        text: filter
        onSearch: {
            filter = text.toLowerCase();
        }
        onClosed: {
            if (view.currentItem.hidden) {
                view.next();
                if (view.currentItem.hidden)
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

        if (ctrl && k === Qt.Key_F ) {
            search();
        } else if (k === Qt.Key_H) {
            view.zoom = 1.0;
            view.state = "FIT-TO-HEIGHT";
        } else if (k === Qt.Key_J || k === Qt.Key_N) {
            view.next()
        } else if (k === Qt.Key_K || k === Qt.Key_B) {
            view.previous()
        } else if (k === Qt.Key_O) {
            horizontal = !horizontal
        } else if (k === Qt.Key_Q || k === Qt.Key_Escape) {
            Qt.quit();
        } else if (k === Qt.Key_W) {
            view.zoom = 1.0;
            view.state = "FIT-TO-WIDTH";
        } else if (k === Qt.Key_Enter || k === Qt.Key_Return) {
            view.forward()
        } else if (k === Qt.Key_Right) {
            view.scroll(100, 0)
        } else if (k === Qt.Key_Left) {
            view.scroll(-100, 0)
        } else if (k === Qt.Key_Up) {
            view.scroll(0, -100)
        } else if (k === Qt.Key_Down) {
            view.scroll(0, 100)
        } else if (k === Qt.Key_Home) {
            view.currentIndex = 0;
        } else if (k === Qt.Key_End) {
            view.currentIndex = view.count-1;
        } else if (k === Qt.Key_PageDown) {
            view.scroll(0, view.height-100)
        } else if (k === Qt.Key_PageUp) {
            view.scroll(0, -view.height+100)
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
