function relToAbs(x, itemWidth) {
    return x+graph.width/2-itemWidth/2
}

function absToRel(x, itemWidth) {
    return x-graph.width/2+itemWidth/2
}

function loadFromFile(file) {
    var request = new XMLHttpRequest();
    request.open("GET", file, false);
    request.send(null);
    var text = request.responseText;
    var lines = text.split("\n")

    graph.clear()

    var nodeCount = parseInt(lines[0])
    for(var i = 0; i < nodeCount; ++i) {
        createNode(0,0)
    }

    var line, i
    var nodeN, relX, relY, node

    for(i = 1; i <= nodeCount; ++i) {
        line = lines[i].split(" ")
        nodeN = parseInt(line[0])
        relX = parseFloat(line[1])
        relY = parseFloat(line[2])
        node = graph.nodeArray[nodeN]
        node.x = relToAbs(relX, node.width)
        node.y = relToAbs(relY, node.width)
    }

    var nodeN1, nodeN2
    for(i = nodeCount+1; i < lines.length; ++i) {
        line = lines[i].split(" ")
        nodeN1 = parseInt(line[0])
        nodeN2 = parseInt(line[1])
        createEdge(graph.nodeArray[nodeN1], graph.nodeArray[nodeN2])
    }

}

function saveToFile(file) {
    var request = new XMLHttpRequest();
    request.open("PUT", file, false);
    var text = graph.nodeArray.length + "\n";
    var node
    for(var i = 0; i < graph.nodeArray.length; ++i) {
        node = graph.nodeArray[i]
        text += i + " " + node.relativeX + " " + node.relativeY + "\n"
    }
    var edge
    for (var i = 0; i < graph.edgeArray.length; ++i) {
        edge = graph.edgeArray[i]
        text += edge.node1.nodeNumber + " " + edge.node2.nodeNumber
    }

    request.send(text);
    return request.status;
}

function createNodeObject(x, y) {
    var component = Qt.createComponent("Node.qml");
    if (component.status === Component.Ready) {
        var node = component.createObject(nodeArea, {"nodeNumber": graph.nodeArray.length});
        if (node == null) {
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

function createEdgeObject(node1, node2) {
    var component = Qt.createComponent("Edge.qml");
    for(var i = 0; i < graph.edgeArray.length; ++i) {
        var edge = graph.edgeArray[i]
        if(edge.node1 === node1 && edge.node2 === node2 || edge.node1 === node2 && edge.node2 === node1)
        {
            return null
        }
    }
    if (component.status === Component.Ready) {
        edge = component.createObject(edgeArea, {"node1": node1, "node2": node2});
        if (edge == null) {
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

function createNode(x, y) {
    var node = createNodeObject(x,y)
    nodeArray.push(node)
    update()
}

function createEdge(node1, node2) {
    for(var i = 0; i < node2.edgeArray.length; ++i) {
        if(node2.edgeArray[i].node1 === node1
                || node2.edgeArray[i].node2 === node1) {
            return
        }
    }
    var edge = createEdgeObject(node1, node2)
    edgeArray.push(edge)
    update()
}

function startEdge(x, y) {
    if(!edgeArea.edgeStarted) {
        var startNode = nodeArea.childAt(x, y)
        if(startNode == null || graph.nodeArray.indexOf(startNode) === -1) {
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
        edgeArea.edgeStarted = false
        var endNode = nodeArea.childAt(x, y)
        if(endNode != null && graph.nodeArray.indexOf(endNode) != -1) {
            createEdge(edgeArea.startNode, endNode)
        }
    }
}
