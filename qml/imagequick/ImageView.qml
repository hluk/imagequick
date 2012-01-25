// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import Qt.labs.folderlistmodel 1.0
import "History.js" as History

Scrollable {
    id: view

    property real zoom: 1.0
    property bool one: false
    property FolderListModel file_model: null

    flickableDirection: Flickable.HorizontalAndVerticalFlick

    function setDirectory(path) {
        file_model = model_component.createObject(view, {folder: path});
        new_model_timer.start();
    }

    function isDirectory(index) {
        return model.isFolder(index);
    }

    function select(index) {
        History.set(index);
        currentIndex = index;
    }

    function current() {
        return History.last();
    }

    function back() {
        /* show multiple items or go to parent folder*/
        if (one) {
            one = false;
        } else {
            History.pop();
            setDirectory(view.model.parentFolder);
        }
    }

    function forward() {
        /* enter folder or show single image */
        if ( currentItem.is_directory() ) {
            History.push(0);
            setDirectory(currentItem.path);
            filter = "";
        } else {
            if (currentItem.is_image) {
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
            if (!currentItem.is_hidden)
                break;
        }
        select(currentItem.is_hidden ? i : currentIndex);
    }

    function previous() {
        /* focus previous visible item */
        var i = currentIndex;
        while(currentIndex > 0) {
            decrementCurrentIndex();
            if (!currentItem.is_hidden)
                break;
        }
        select(currentItem.is_hidden ? i : currentIndex);
    }

    state: "FIT"

    Behavior on zoom {
        NumberAnimation {
            duration: zoom_duration
            easing.type: Easing.OutQuad;
        }
    }

    /* model */
    Timer {
        id: new_model_timer
        interval: 100; running:false; repeat: false
        onTriggered: model = file_model
    }
    Component {
        id: model_component
        FolderListModel {
            id: folder_model
            sortField: FolderListModel.Name
        }
    }

    /* delegate */
    delegate: ImageItem {
        property string _filename: fileName
        property string _path: filePath

        function path() { return _path; }
        function filename() { return _filename; }
        function item_index() { return index; }
        function is_directory() { return isDirectory(index); }
        property bool is_current: ListView.isCurrentItem
        property bool is_hidden: !isMatched(filename(), filter)
    }

    /* progress */
    Text {
        id: progress
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 6
        color: "white"
        style: Text.Outline
        styleColor: "black"
        text: (currentIndex+1) + "/" + count
        opacity: 0

        font {
            pixelSize: 18
            bold: true
        }

        Behavior on text {
            SequentialAnimation {
                id: progress_animation
                running: false
                NumberAnimation {
                    target: progress
                    property: "opacity"
                    to: 0.7
                    duration: 500
                }
                NumberAnimation {
                    target: progress
                    property: "opacity"
                    to: 0.0
                    duration: 4000
                    easing.type: Easing.InQuint
                }
            }
        }
    }

    onCountChanged: {
        var last = History.last();
        if (currentIndex !== last && last < count) {
            positionViewAtIndex(last, ListView.Beginning);
            currentIndex = last;
        }
    }

    onOrientationChanged: {
        if (currentIndex >= 0)
            positionViewAtIndex(currentIndex, ListView.Contain);
    }
}
