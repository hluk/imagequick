// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

ListView {
    id: view

    orientation: horizontal ? ListView.Horizontal : ListView.Vertical
    highlightResizeDuration: scroll_duration
    highlightMoveDuration: scroll_duration

    function scroll(x, y) {
        if ( x && (x < 0 || !horizontal || !atXEnd) )
            contentX = Math.max(0, contentX+x);
        if ( y && (y < 0 || horizontal || !atYEnd) )
            contentY = Math.max(0, contentY+y);
    }

    Behavior on contentX {
        NumberAnimation {
            duration: scroll_duration
            easing.type: Easing.OutQuad;
        }
    }
    Behavior on contentY {
        NumberAnimation {
            duration: scroll_duration
            easing.type: Easing.OutQuad;
        }
    }
}
