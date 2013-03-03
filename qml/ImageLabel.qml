import QtQuick 2.0

Item {
    width:  labelText.width+40
    height: labelText.height+10
    Text {
        id: labelText
        anchors.horizontalCenter: parent.horizontalCenter
        visible: !one || image.status !== Image.Ready
        color: isCurrent ? colorCurrent : isDirectory() ? colorDirectory : isImage ? colorImage : colorOther
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
