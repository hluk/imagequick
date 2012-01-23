// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

ListView {
    id: view

    orientation: horizontal ? ListView.Horizontal : ListView.Vertical
    highlightResizeDuration: scroll_duration
    highlightMoveDuration: scroll_duration

    function scroll(x, y) {
        var err, index;
        err = 4;
        if (x < 0) {
            if (!horizontal) {
                contentX = Math.max(contentX+x, 0);
            } else if ( indexAt(contentX-err, 0) !== currentIndex ) {
                previous();
                contentY = 0;
                if (currentItem.x < contentX) {
                    contentX = currentItem.x +
                            Math.max(0, currentItem.width - width);
                }
            } else if (!atXBeginning) {
                contentX += x;
            }
        } else if (x > 0) {
            if (!horizontal) {
                if (currentItem.x + currentItem.width > contentX + width + err)
                    contentX = Math.min(contentX+x, currentItem.x + currentItem.width - width);
            } else if ( indexAt(contentX + width + err, 0) !== currentIndex ) {
                next();
                contentY = 0;
                if (currentItem.x + currentItem.width > contentX + width) {
                    contentX = currentItem.x -
                            Math.max(0, width - currentItem.width);
                }
            } else if (!atXEnd) {
                contentX += x;
            }
        }

        if (y < 0) {
            if (horizontal) {
                contentY = Math.max(contentY+y, 0);
            } else if ( indexAt(0, contentY-err) !== currentIndex ) {
                previous();
                if (currentItem.y < contentY) {
                    contentY = currentItem.y +
                            Math.max(0, currentItem.height - height);
                }
            } else if (!atYBeginning) {
                contentY += y;
            }
        } else if (y > 0) {
            if (horizontal) {
                if (currentItem.y + currentItem.height > contentY + height + err)
                    contentY = Math.min(contentY+y, currentItem.y + currentItem.height - height);
            } else if ( indexAt(0, contentY + height + err) !== currentIndex ) {
                next();
                contentX = 0;
                if (currentItem.y + currentItem.height > contentY + height) {
                    contentY = currentItem.y -
                            Math.max(0, height - currentItem.height);
                }
            } else if (!atYEnd) {
                contentY += y;
            }
        }
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
