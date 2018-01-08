import QtQuick 2.0
import QtQuick.Controls 1.4
import "Graph.js" as Graph


Rectangle {
    id: graph
    property string mode: "Node"
    property var nodeArray: []
    property var edgeArray: []

    function loadFromFile(file) {
        Graph.loadFromFile(file)
    }

    function saveToFile(file) {
        Graph.saveToFile(file)
    }

    function update() {
        var na = nodeArray
        nodeArray = new Array(0)
        nodeArray = na
        var ea = edgeArray
        edgeArray = new Array(0)
        edgeArray = ea
    }

    function nodeDied(number) {
        for(var i = number+1; i < nodeArray.length; ++i)
        {
            nodeArray[i].nodeNumber -= 1
        }
        nodeArray.splice(number, 1)
        update()
    }

    function edgeDied(edge) {
        var i = edgeArray.indexOf(edge)
        edgeArray.splice(i, 1)
        update()
    }

    function clear() {
        var len = nodeArray.length
        for(var i = 0; i < len; ++i)
        {
            nodeArray[nodeArray.length-1].kys()
        }
        update()
    }

    Item {
        id: edgeArea
        property bool edgeStarted: false
        property var startNode: undefined
        property var endNode: undefined
        anchors.fill: parent
        Line {
            id: edgeLine
            startX: 0
            startY: 0
            endX: nodeMouseArea.mouseX
            endY: nodeMouseArea.mouseY
            visible: parent.edgeStarted
        }
    }

    Item {
        id: nodeArea
        anchors.fill: parent
        MouseArea {
            visible: graph.mode === "Node"
            anchors.fill: parent
            onClicked: Graph.createNode(mouse.x, mouse.y)
        }

        MouseArea {
            id: nodeMouseArea
            visible: graph.mode === "Edge"
            anchors.fill: parent
            onPressed: Graph.startEdge(mouse.x, mouse.y)
            onReleased: Graph.endEdge(mouse.x, mouse.y)
        }
    }
}
