import QtQuick 2.2

Item {
    width:  labelText.width+40
    height: labelText.height+10
    Text {
        id: labelText
        anchors.horizontalCenter: parent.horizontalCenter
        visible: !page.one || image.status !== Image.Ready
        color: isCurrent ? page.colorCurrent : isDirectory() ? page.colorDirectory : isImage ? page.colorImage : page.colorOther
        text: "<strong>" + (itemTitle() || filename()) + "</strong>" +
              (image.status === Image.Loading ?
                   "<br /><small>"+parseInt(100*image.progress)+"% loaded</small>" :
                   (image.status === Image.Ready ?
                        "<br /><small>"+(itemWidth()||image.implicitWidth)+"x"+(itemHeight()||image.implicitHeight)+"</small>" :
                        ""))

        style: Text.Outline
        styleColor: "black"

        font {
            pixelSize: 16
            underline: isCurrent && isDirectory()
        }
    }
}
