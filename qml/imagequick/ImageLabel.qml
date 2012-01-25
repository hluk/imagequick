// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    width:  image.status === Image.Loading ? view.width  : label_text.width+40
    height: image.status === Image.Loading ? view.height : label_text.width+10
    Text {
        id: label_text
        anchors.horizontalCenter: parent.horizontalCenter
        visible: !one || image.status !== Image.Ready
        color: is_current ? color_current : is_directory() ? color_directory : is_image ? color_image : color_other
        text: "<strong>" + filename() + "</strong>" +
              (image.status === Image.Loading ?
                   parseInt(100*image.progress)+"% loaded" :
                   (image.status === Image.Ready ?
                        "<br /><small>"+image.implicitWidth+"x"+image.implicitHeight+"</small>" :
                        ""))

        style: Text.Outline
        styleColor: "black"

        font {
            pixelSize: 16
            underline: is_current && is_directory()
        }
    }
}
