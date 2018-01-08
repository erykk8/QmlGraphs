import QtQuick 2.0

Line {
    property var node1: null
    property var node2: null
    size: 2
    z: 0
    startX: node1 != null ? node1.nodeX : 0
    startY: node1 != null ? node1.nodeY : 0
    endX: node2 != null ? node2.nodeX : 0
    endY: node2 != null ? node2.nodeY : 0

    function kys() {
        if(node1 != null) {
            node1.edgeDied(this)
        }
        if(node2 != null) {
            node2.edgeDied(this)
        }
        graph.edgeDied(this)
        destroy()
    }

    MouseArea {
        visible: graph.mode === "Delete"
        anchors.fill: parent
        onClicked: parent.kys()
    }
}
