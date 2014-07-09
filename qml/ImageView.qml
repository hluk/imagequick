import QtQuick 2.2
import QtQuick.XmlListModel 2.0
import Qt.labs.folderlistmodel 1.0
import "History.js" as History

Scrollable {
    id: view

    property real zoom: 1.0
    property FolderListModel newFileModel: null
    property XmlListModel newXmlModel: null
    property real sharpenStrength: 0.0

    flickableDirection: Flickable.HorizontalAndVerticalFlick

    function source() {
        return newFileModel ?
                    newFileModel.folder :
                    newXmlModel ?
                        newXmlModel.source :
                        undefined;
    }

    function isLocal(path) {
        return ("" + path).slice(0, 7) === "file://";
    }

    function setSource(path) {
        if (("" + path).slice(0, 1) === "/")
            path = "file://" + path;
        if ( isLocal(path) ) {
            newXmlModel = null;
            newFileModel = fileModelComponent.createObject(view, {folder: path});
        } else {
            newFileModel = null;
            newXmlModel = xmlModelComponent.createObject(view, {source: path});
        }
        newModelTimer.start();
    }

    function goTo(path) {
        History.push(0);
        setSource(path);
        page.filter = "";
    }

    function isItemDirectory(index) {
        return newFileModel !== null && model.isFolder(index);
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
        if (page.one) {
            page.one = false;
            page.single = "";
        } else {
            if (page.filter) {
                page.filter = "";
            } else if (newFileModel) {
                History.pop();
                setSource(view.model.parentFolder);
            }
        }
    }

    function forward() {
        /* enter folder or show single image */
        if ( currentItem.isDirectory() ) {
            goTo( currentItem.path() );
        } else {
            if (currentItem.isImage) {
                page.one = !page.one;
                page.single = "";
                positionViewAtIndex(currentIndex, ListView.Contain);
            }
        }
    }

    function setHistory(history) {
        History.setHistory(history);
    }

    function getHistory() {
        return History.getHistory();
    }

    function next() {
        /* focus next visible item */
        var i = currentIndex;
        while(currentIndex+1 < count) {
            incrementCurrentIndex();
            if (!currentItem.isHidden)
                break;
        }
        select(currentItem.isHidden ? i : currentIndex);
    }

    function previous() {
        /* focus previous visible item */
        var i = currentIndex;
        while(currentIndex > 0) {
            decrementCurrentIndex();
            if (!currentItem.isHidden)
                break;
        }
        select(currentItem.isHidden ? i : currentIndex);
    }

    function reload() {
        if (newXmlModel)
            model.reload();
        else
            setSource(model.folder);
    }

    state: "FIT"

    Behavior on zoom {
        NumberAnimation {
            duration: page.zoomDuration
            easing.type: Easing.OutQuad;
        }
    }

    /* model */
    Timer {
        id: newModelTimer
        interval: 100; running:false; repeat: false
        onTriggered: {
            if (newFileModel) {
                model = newFileModel;
                cacheBuffer = 0;
            } else {
                model = newXmlModel;
                cacheBuffer = 4096;
            }
        }
    }
    Component {
        id: fileModelComponent
        FolderListModel {
            id: fileModel
            sortField: FolderListModel.Name
            showDirs: page.single === ""
            nameFilters: page.single ? [page.single] : []
        }
    }
    Component {
        id: xmlModelComponent
        XmlListModel {
            id: xmlModel
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
    property string title: ""
    property int itemWidth: 0
    property int itemHeight: 0
    delegate: ImageItem {
        function path(hires) {
            var url = hires && filePathBig || filePath || "";
            if (url.slice(0, 1) === "/")
                url = "file://" + url;
            return url;
        }
        function filename() { return fileName || filePath || ""; }
        function itemTitle() { return title || ""; }
        function itemIndex() { return index; }
        function itemWidth() { return newXmlModel ? itemWidth : 0; }
        function itemHeight() { return newXmlModel ? itemHeight : 0; }
        function isDirectory() { return isItemDirectory(index); }
        property bool isCurrent: ListView.isCurrentItem
        property bool isHidden: !page.isMatched(filename(), page.filter)
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

    /* zoom label */
    Osd {
        id: labelZoom
        anchors.right: parent.right
        anchors.top: parent.top
        text: "zoom: " + Math.round(zoom*100) + " %"
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
