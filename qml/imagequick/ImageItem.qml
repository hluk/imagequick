import QtQuick 1.1
import Qt.labs.shaders 1.0

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

    ShaderEffectItem {
        id: shaderSharpen
        property variant tex: ShaderEffectSource {
            sourceItem: image
            hideSource: true
        }
        property real w: 1.0/image.width
        property real h: 1.0/image.height
        property real strength: sharpenStrength
        anchors.fill: image
        blending: false;
        visible: strength > 0.0

        fragmentShader: "
            varying highp vec2 qt_TexCoord0;
            uniform sampler2D tex;
            uniform highp float w;
            uniform highp float h;
            uniform highp float strength;

            void main(void)
            {
                vec2 xy = qt_TexCoord0.xy;
                vec4 col = 9.0 * texture2D(tex, xy);

                col -= texture2D(tex, xy + vec2(-w, h));
                col -= texture2D(tex, xy + vec2(0.0, h));
                col -= texture2D(tex, xy + vec2(w, h));
                col -= texture2D(tex, xy + vec2(-w, 0.0));

                col -= texture2D(tex, xy + vec2(w, 0.0));
                col -= texture2D(tex, xy + vec2(0.0, -h));
                col -= texture2D(tex, xy + vec2(w, -h));
                col -= texture2D(tex, xy + vec2(-w, -h));
                col = col * strength + (1.0 - strength) * texture2D(tex, xy);
                gl_FragColor = col;
            }
            "
    }

    ImageLabel {
        id: label
    }
}
