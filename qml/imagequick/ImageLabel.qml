import QtQuick 1.1

Item {
    width:  label_text.width+40
    height: label_text.height+10
    Text {
        id: label_text
        anchors.horizontalCenter: parent.horizontalCenter
        visible: !one || image.status !== Image.Ready
        color: is_current ? color_current : is_directory() ? color_directory : is_image ? color_image : color_other
        text: "<strong>" + (item_title() || filename()) + "</strong>" +
              (image.status === Image.Loading ?
                   "<br /><small>"+parseInt(100*image.progress)+"% loaded</small>" :
                   (image.status === Image.Ready ?
                        "<br /><small>"+(item_width()||image.implicitWidth)+"x"+(item_height()||image.implicitHeight)+"</small>" :
                        ""))

        style: Text.Outline
        styleColor: "black"

        font {
            pixelSize: 16
            underline: is_current && is_directory()
        }
    }
}
