import QtQuick 2.0
import "Graph.js" as Graph


Rectangle {
    id: graphArea
    property string mode: "Node"
    property var nodeArray: []
    property var edgeArray: []

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
    }

    function createNode(x, y) {
        createNodeAbsolutePosition(x + width/2, y + width/2)
    }

    function createNodeAbsolutePosition(x, y) {
        var node = Graph.createNode(x,y)
        nodeArray.push(node)
        update()
    }

    function createEdge(i, j) {
        var n1 = nodeArray[i]
        var n2 = nodeArray[j]
        var edge = Graph.createEdge(n1, n2)
        edgeArray.push(edge)
        update()
    }

    function loadFromFile(file) {
        Graph.loadFromFile(file)
    }

    function saveToFile(file) {
        Graph.saveToFile(file)
    }

    function startEdge(x, y) {
        if(!edgeArea.edgeStarted) {
            var startNode = nodeArea.childAt(x, y)
            if(graphArea.nodeArray.indexOf(startNode) === -1) {
                edgeArea.startNode = null
                return
            }
            edgeArea.startNode = startNode
            edgeLine.startX = startNode.nodeX
            edgeLine.startY = startNode.nodeY
            edgeArea.edgeStarted = true
        }
    }

    function endEdge(x, y) {
        if(edgeArea.edgeStarted) {
            var endNode = nodeArea.childAt(x, y)
            if(graphArea.nodeArray.indexOf(endNode) != -1) {
                createEdge(edgeArea.startNode.nodeNumber, endNode.nodeNumber)
            }
            edgeArea.edgeStarted = false
        }
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
            visible: graphArea.mode === "Node"
            anchors.fill: parent
            onClicked: createNodeAbsolutePosition(mouse.x, mouse.y)
        }

        MouseArea {
            id: nodeMouseArea
            visible: graphArea.mode === "Edge"
            anchors.fill: parent
            onPressed: startEdge(mouse.x, mouse.y)
            onReleased: endEdge(mouse.x, mouse.y)
        }
    }
}
