// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

ListView {
    id: view

    orientation: horizontal ? ListView.Horizontal : ListView.Vertical
    //snapMode: ListView.SnapToItem

    highlightMoveDuration: 250
    highlightResizeDuration: 250

    function scroll(x, y) {
        var err, end, scroll;
        err = 16;
        if (x < 0) {
            scroll = contentX + err;
            if ( horizontal && (atXBeginning || scroll < currentItem.x) ) {
                decrementCurrentIndex();
                contentY = 0;
            } else if (scroll > 0) {
                contentX += x;
            }
        } else if (x > 0) {
            scroll = contentX + width;
            end = currentItem.x + currentItem.width + err;
            if ( horizontal && (atXEnd || scroll > end) ) {
                incrementCurrentIndex();
                contentY = 0;
            } else if (scroll <= end) {
                contentX += x;
            }
        }

        if (y < 0) {
            scroll = contentY + err;
            if ( !horizontal && (atYBeginning || scroll < currentItem.y) ) {
                decrementCurrentIndex();
                contentX = 0;
            } else if (scroll > 0) {
                contentY += y
            }
        } else if (y > 0) {
            scroll = contentY + height;
            end = currentItem.y + currentItem.height + err;
            if ( !horizontal && (atYEnd || scroll > end) ) {
                incrementCurrentIndex();
                contentX = 0;
            } else if (scroll <= end) {
                contentY += y
            }
        }
    }
}
