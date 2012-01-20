// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import Qt.labs.folderlistmodel 1.0

Scrollable {
    id: view

    property string history_str: "0"
    property real zoom: 1.0
    property bool one: false

    function pushHistory(item) {
        history_str += ","+item;
    }

    function popHistory() {
        var str, i, last;

        str = history_str.toString();
        i = str.lastIndexOf(",");
        last = str.slice(i+1);
        history_str = str.slice(0,i);

        return last ? parseInt(last) : undefined;
    }

    function back() {
        if (one)
            one = false;
        else
            view.model.folder = view.model.parentFolder;
    }

    function forward() {
        if ( model.isFolder(view.currentIndex) ) {
            pushHistory(currentIndex);
            pushHistory(0);
            model.folder = currentItem.path;
        } else {
            one = !one;
        }
    }

    state: "FIT"

    Behavior on zoom {
        NumberAnimation {
            duration: 250
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
        id: image
    }

    onCountChanged:  {
        var current = popHistory();
        if (current < count)
            currentIndex = current;
        else
            pushHistory(current);
    }

    onOrientationChanged: {
        if (currentIndex >= 0)
            positionViewAtIndex(currentIndex, ListView.Contain);
    }
}
