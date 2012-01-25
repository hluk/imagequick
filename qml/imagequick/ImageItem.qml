// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    id: item

    property bool is_image: image.status !== Image.Error

    opacity: is_hidden ? 0.0 : 1.0
    scale: opacity

    width:  opacity *
            Math.max( image.width, label.width,
                     ((one || !horizontal) ? view.width : 0) )
    height: opacity *
            Math.max( image.height, label.height,
                     ((one || horizontal) ? view.height : 0) )

    Behavior on opacity {
        NumberAnimation {
            duration: show_duration
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            select(item_index)
        }
        onDoubleClicked: {
            select(item_index)
            forward()
        }
    }

    Picture {
        id: image
    }

    ImageLabel {
        id: label
    }
}
