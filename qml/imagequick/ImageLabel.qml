// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Text {
    visible: !one || image.status !== Image.Ready
    color: is_current ? color_current :
             is_dir ? color_directory :
               is_image ? color_image :
                 color_other
    text: "<strong>"+filename+"</strong>"+
          (image.status === Image.Loading ?
               parseInt(100*image.progress)+"% loaded" :
               (is_loaded ?
                    "<br /><small>"+image.implicitWidth+"x"+image.implicitHeight+"</small>" :
                    ""))

    width: implicitWidth+100

    style: Text.Outline
    styleColor: "black"

    font {
        pixelSize: 16
        underline: is_current && is_dir
    }
}
