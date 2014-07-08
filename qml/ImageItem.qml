import QtQuick 2.2

Item {
    id: item

    property bool isImage: image.status !== Image.Error

    opacity: isHidden ? 0.0 : 1.0
    scale: opacity

    width:  opacity *
            Math.max( image.width, label.width,
                     ((page.one || !page.horizontal) ? view.width : 0) )
    height: opacity *
            Math.max( image.height, label.height,
                     ((page.one || page.horizontal) ? view.height : 0) )

    Behavior on opacity {
        NumberAnimation {
            duration: showDuration
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            select(itemIndex)
        }
        onDoubleClicked: {
            select(itemIndex)
            forward()
        }
    }

    Picture {
        id: image
    }

    ShaderEffect {
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
