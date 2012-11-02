import QtQuick 1.1

Row {
    property alias label: labelText.text
    property alias help: helpText.text

    Text {
        id: labelText
        color: "#333"
        font.bold: true
        font.pointSize: 12
    }

    Text {
        text: "  ...  "
        color: "black"
        font.pointSize: 12
    }

    Text {
        id: helpText
        text: help
        color: "black"
        font.pointSize: 12
    }
}
