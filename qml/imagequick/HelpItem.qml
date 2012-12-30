import QtQuick 2.0

Row {
    property alias label: labelText.text
    property alias help: helpText.text

    property bool isHeader: help === ""

    anchors.horizontalCenter: parent.horizontalCenter

    Text {
        id: labelText
        color: isHeader ? "#666" : "#333"
        font {
            bold: true
            pointSize: isHeader ? 14 : 12
        }
    }

    Text {
        text: "  ...  "
        opacity: isHeader ? 0 : 1
        color: "black"
        font.pointSize: 12
    }

    Text {
        id: helpText
        color: "black"
        font.pointSize: 12
    }
}
