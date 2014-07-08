import QtQuick 2.2

ListView {
    id: view

    orientation: page.horizontal ? ListView.Horizontal : ListView.Vertical
    highlightResizeDuration: page.scrollDuration
    highlightMoveDuration: page.scrollDuration

    function scrollBy(value, xy, wh, moveHorizontally) {
        var err, h, v, size, indexAtFn;

        err = 4;
        if (moveHorizontally) {
            h = "contentX";
            v = "contentY";
            size = width;
            indexAtFn = indexAt;
        } else {
            h = "contentY";
            v = "contentX";
            size = height;
            indexAtFn = function(y, x) { return indexAt(x, y); };
        }

        if (value < 0) {
            if (moveHorizontally !== page.horizontal) {
                view[h] = Math.max(view[h] + value, 0);
            } else if ( indexAtFn(view[h] - err, 0) !== currentIndex ) {
                previous();
                view[v] = 0;
                if (currentItem[xy] < view[h]) {
                    view[h] = currentItem[xy] + Math.max(0, currentItem[wh] - size);
                }
            } else if (moveHorizontally ? !atXBeginning : !atYBeginning) {
                view[h] += value;
            }
        } else if (value > 0) {
            if (moveHorizontally !== page.horizontal) {
                if (currentItem[xy] + currentItem[wh] > view[h] + size + err)
                    view[h] = Math.min(view[h] + value, currentItem[xy] + currentItem[wh] - size);
            } else if ( indexAtFn(view[h] + size + err, 0) !== currentIndex ) {
                next();
                view[v] = 0;
                if (currentItem[xy] + currentItem[wh] > view[h] + size) {
                    view[h] = currentItem[xy] - Math.max(0, size - currentItem[wh]);
                }
            } else if (moveHorizontally ? !atXEnd : !atYEnd) {
                view[h] += value;
            }
        }
    }

    function scroll(x, y) {
        scrollBy(x, "x", "width", true);
        scrollBy(y, "y", "height", false);
    }

    function updateScroll() {
        var index = indexAt(contentX + width/2, contentY + height/2);
        if (index !== -1 && index !== currentIndex) {
            behaviorContextX.enabled = behaviorContextY.enabled = false;
            var x = contentX;
            var y = contentY;
            currentIndex = index;
            contentX = x;
            contentY = y;
            behaviorContextX.enabled = behaviorContextY.enabled = true;
        }
    }

    Behavior on contentX {
        id: behaviorContextX
        NumberAnimation {
            duration: page.scrollDuration
            easing.type: Easing.OutQuad;
        }
    }
    Behavior on contentY {
        id: behaviorContextY
        NumberAnimation {
            duration: page.scrollDuration
            easing.type: Easing.OutQuad;
        }
    }

    onFlickEnded: updateScroll()
    onMovementEnded: updateScroll()
}
