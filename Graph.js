function loadFromFile(file) {
    //stub
}

function saveToFile(file) {
    //stub
}

function createNode(x, y) {
    var component = Qt.createComponent("Node.qml");
    if (component.status === Component.Ready) {
        var node = component.createObject(nodeArea, {"nodeNumber": graphArea.nodeArray.length});
        if (node === null) {
            console.log("Error creating node");
        }
        else {
            node.x = x-node.width/2
            node.y = y-node.height/2
            return node
        }
    }
    return null
}

function createEdge(node1, node2) {
    var component = Qt.createComponent("Edge.qml");
    for(var i = 0; i < graphArea.edgeArray.length; ++i) {
        var edge = graphArea.edgeArray[i]
        if(edge.node1 === node1 && edge.node2 === node2 || edge.node1 === node2 && edge.node2 === node1)
        {
            return null
        }
    }
    if (component.status === Component.Ready) {
        edge = component.createObject(edgeArea, {"node1": node1, "node2": node2});
        if (edge === null) {
            console.log("Error creating node");
        }
        else {
            node1.edgeArray.push(edge)
            node2.edgeArray.push(edge)
            return edge
        }
    }
    return null
}
