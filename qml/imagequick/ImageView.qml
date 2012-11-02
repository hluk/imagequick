// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import Qt.labs.folderlistmodel 1.0
import "History.js" as History

Scrollable {
    id: view

    property real zoom: 1.0
    property FolderListModel new_file_model: null
    property XmlListModel new_xml_model: null
    property real sharpenStrength: 0.0

    flickableDirection: Flickable.HorizontalAndVerticalFlick

    function source() {
        return new_file_model ?
                    new_file_model.folder :
                    new_xml_model ?
                        new_xml_model.source :
                        undefined;
    }

    function isLocal(path) {
        return new String(path).slice(0, 7) === "file://";
    }

    function setSource(path) {
        if ( isLocal(path) ) {
            new_xml_model = null;
            new_file_model = file_model_component.createObject(view, {folder: path});
        } else {
            new_file_model = null;
            new_xml_model = xml_model_component.createObject(view, {source: path});
        }
        new_model_timer.start();
    }

    function goTo(path) {
        History.push(0);
        setSource(path);
        filter = "";
    }

    function isDirectory(index) {
        return new_file_model !== null && model.isFolder(index);
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
            single = "";
        } else {
            if (filter) {
                filter = "";
            } else if (new_file_model) {
                History.pop();
                setSource(view.model.parentFolder);
            }
        }
    }

    function forward() {
        /* enter folder or show single image */
        if ( currentItem.is_directory() ) {
            goTo( currentItem.path() );
        } else {
            if (currentItem.is_image) {
                one = !one;
                single = "";
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

    function reload() {
        if (new_xml_model)
            model.reload();
        else
            setSource(model.folder);
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
        onTriggered: {
            if (new_file_model) {
                model = new_file_model;
                cacheBuffer = 0;
            } else {
                model = new_xml_model;
                cacheBuffer = 4096;
            }
        }
    }
    Component {
        id: file_model_component
        FolderListModel {
            id: file_model
            sortField: FolderListModel.Name
            showDirs: single === ""
            nameFilters: single ? [single] : []
        }
    }
    Component {
        id: xml_model_component
        XmlListModel {
            id: xml_model
            query: "/rss/channel/item"
            namespaceDeclarations: "declare namespace media=\"http://search.yahoo.com/mrss/\";"

            XmlRole { name: "itemTitle"; query: "title/string()" }
            /* filePath is last thumbnail */
            XmlRole { name: "filePath"; query: "(*|.)/media:thumbnail[last()]/@url/string()" }
            /* filePathBig is last content (maybe bigger image) */
            XmlRole { name: "filePathBig"; query: "(*|.)/media:content[last()]/@url/string()" }
            XmlRole { name: "itemWidth"; query: "(*|.)/media:content[last()]/@width/string()" }
            XmlRole { name: "itemHeight"; query: "(*|.)/media:content[last()]/@height/string()" }
        }
    }

    /* delegate */
    property string fileName: ""
    property string filePath: ""
    property string filePathBig: ""
    property string itemTitle: ""
    property int itemWidth: 0
    property int itemHeight: 0
    delegate: ImageItem {
        function path(hires) { return hires && filePathBig || filePath || ""; }
        function filename() { return fileName || filePath || ""; }
        function item_title() { return itemTitle || ""; }
        function item_index() { return index; }
        function item_width() { return new_xml_model ? itemWidth : 0; }
        function item_height() { return new_xml_model ? itemHeight : 0; }
        function is_directory() { return isDirectory(index); }
        property bool is_current: ListView.isCurrentItem
        property bool is_hidden: !isMatched(filename(), filter)
    }

    /* progress */
    Osd {
        id: progress
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        text: (currentIndex+1) + "/" + count
    }

    /* sharpen label */
    Osd {
        id: labelSharpen
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        text: "sharpen: " + Math.round(sharpenStrength*100) + " %"
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
