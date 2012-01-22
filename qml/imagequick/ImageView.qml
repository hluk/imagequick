// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import Qt.labs.folderlistmodel 1.0
import "History.js" as History

Scrollable {
    id: view

    property real zoom: 1.0
    property bool one: false

    function back() {
        /* show multiple items or go to parent folder*/
        if (one)
            one = false;
        else
            view.model.folder = view.model.parentFolder;
    }

    function forward() {
        /* enter folder or show single image */
        if ( model.isFolder(view.currentIndex) ) {
            History.push(currentIndex);
            History.push(0);
            model.folder = currentItem.path;
            filter = "";
        } else {
            if (currentItem.loaded) {
                one = !one;
                positionViewAtIndex(currentIndex, ListView.Contain);
            }
        }
    }

    function next() {
        /* focus next visible item */
        var i = currentIndex;
        while(currentIndex+1 < count) {
            incrementCurrentIndex();
            if (!currentItem.hidden)
                return;
        }
        currentIndex = i;
    }

    function previous() {
        /* focus previous visible item */
        var i = currentIndex;
        while(currentIndex > 0) {
            decrementCurrentIndex()
            if (!currentItem.hidden)
                return;
        }
        currentIndex = i;
    }

    state: "FIT"

    Behavior on zoom {
        NumberAnimation {
            duration: zoom_duration
            easing.type: Easing.OutQuad;
        }
    }

    model: FolderListModel {
        id: model
        folder: src
        sortField: FolderListModel.Name
        //nameFilters: [ "*.JPG", "*.jpg", "*.PNG", "*.png" ]
        //showDirs: false
    }

    delegate: ImageItem {
        id: item
    }

    onCountChanged:  {
        var current = History.pop();
        if (current < count)
            currentIndex = current;
        else
            History.push(current);
    }

    onOrientationChanged: {
        if (currentIndex >= 0)
            positionViewAtIndex(currentIndex, ListView.Contain);
    }
}
