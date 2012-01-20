import QtQuick 1.1

Rectangle {
    id: page
    width: 360
    height: 360
    color: "black"
    focus: true

    property string src: "/home/lukas/Pictures"
    property bool horizontal: true

    function toggle(dest, arg1, arg2)
    {
        dest = (dest === arg1) ? arg2 : arg1;
    }

    /* main view */
    ImageView {
        id: view
        width: page.width
        height: page.height
    }

    /* keyboard */
    Keys.onBackPressed:   view.back()
    Keys.onAsteriskPressed: {
        view.zoom = 1.0;
        view.state = "NORMAL";
    }
    Keys.onPressed: {
        var max, k, shift;
        k = event.key;
        event.accepted = true;

        if (k === Qt.Key_H) {
            view.zoom = 1.0;
            view.state = "FIT-TO-HEIGHT";
        } else if (k === Qt.Key_J || k === Qt.Key_N) {
            view.incrementCurrentIndex()
        } else if (k === Qt.Key_K || k === Qt.Key_B) {
            view.decrementCurrentIndex()
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
        } else if (k === Qt.Key_Space) {
            shift = (event.modifiers & Qt.ShiftModifier) ? -1 : 1;
            if (horizontal)
                view.scroll( shift * (view.width-100), 0 )
            else
                view.scroll( 0, shift * (view.height-100) )
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
