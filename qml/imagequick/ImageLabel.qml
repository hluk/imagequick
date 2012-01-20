// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Text {
    visible: !one || image.status !== Image.Ready
    color: parent.ListView.isCurrentItem ? "yellow" : "white"
    text: "<b>"+fileName+"</b>"+
          (image.status === Image.Loading ?
               parseInt(100*image.progress)+"% loaded" :
               (image.status === Image.Ready ?
                    "<br /><small>"+image.implicitWidth+"x"+image.implicitHeight+"</small>" :
                    ""))

    width: implicitWidth+100

    style: Text.Outline
    styleColor: "black"

    font {
        underline: parent.ListView.isCurrentItem
        pixelSize: 16
        //bold: true
        //italic: parent.ListView.model.isFolder(index)
    }
}
