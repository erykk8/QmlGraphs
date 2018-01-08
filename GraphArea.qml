import QtQuick 2.0
import QtQuick.Layouts 1.2
import QtQuick.Controls 1.4

GridLayout {
    property alias mode: graph.mode
    property alias graph: graph
    function adjustZoom(amount) {
        if(amount < 1 && graph.scale < 0.01) return
        if(amount > 1 && graph.scale > 8) return
        graph.adjustZoom(amount)
    }

    id: graphLayout
    anchors.fill: parent
    columns: 2
    rows: 2

    ScrollView {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.minimumHeight: 200
        Layout.minimumWidth: 200
        Layout.rowSpan: 2
        Layout.columnSpan: 1
        Layout.row: 0
        Layout.column: 0

        flickableItem.contentX: flickableItem.contentWidth/2 - width/2
        flickableItem.contentY: flickableItem.contentHeight/2 - height/2
        flickableItem.interactive: graph.mode === "Move"


        Graph {
            width: 16384
            height: 16384
            id: graph
            function adjustZoom(amount) {
                scale *= amount
            }

            transformOrigin: Item.Center
            scale: 1.0
        }
    }

    Component {
        id: nodeDelegate
        Rectangle {
            Layout.fillWidth: true
            height: 40
            radius: 4
            ColumnLayout {
                anchors.centerIn: parent
                Text {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    text: 'Node: ' + modelData.nodeNumber
                }
                Text {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    text: 'Position: ' + modelData.relativeX + ' ' + modelData.relativeY
                }
            }
        }
    }

    Component {
        id: edgeDelegate
        Rectangle {
            Layout.fillWidth: true
            height: 40
            radius: 4
            property int n1: modelData.node1.nodeNumber
            property int n2: modelData.node2.nodeNumber
            Text {
                anchors.centerIn: parent
                text: n1 + ' --- ' + n2
            }
        }
    }

    Item {
        Layout.fillHeight: true
        Layout.minimumWidth: 100
        Layout.preferredWidth: 200
        Layout.row: 0
        Layout.column: 1

        ColumnLayout {
            anchors.fill: parent
            Label {
                text: "Nodes"
                Layout.alignment: Layout.Center
                Layout.minimumHeight: 20
            }

            ScrollView {
                Layout.fillHeight: true
                Layout.fillWidth: true

                horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
                ColumnLayout {
                    width: 200
                    Repeater {
                        model: graph.nodeArray
                        delegate: nodeDelegate
                    }
                }
            }

        }
    }

    Item {
        Layout.fillHeight: true
        Layout.minimumWidth: 100
        Layout.preferredWidth: 200
        Layout.row: 1
        Layout.column: 1

        ColumnLayout {
            anchors.fill: parent
            Label {
                text: "Edges"
                Layout.alignment: Layout.Center
                Layout.minimumHeight: 20
            }

            ScrollView {
                Layout.fillHeight: true
                Layout.fillWidth: true

                horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
                ColumnLayout {
                    width: 200
                    Repeater {
                        model: graph.edgeArray
                        delegate: edgeDelegate
                    }
                }
            }

        }
    }
}
