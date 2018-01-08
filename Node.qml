import QtQuick 2.7
Rectangle {
    color: 'black'
    width: 32
    height: width
    radius: width
    x: 0
    y: 0
    z: 1
    transformOrigin: Item.Center


    property int relativeX: nodeX-graph.width/2
    property int relativeY: nodeY-graph.height/2
    property int nodeX: x+width/2
    property int nodeY: y+height/2
    property int nodeNumber: 0
    property var edgeArray: []

    Text {
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: nodeNumber
        color: 'white'
        font {
            pixelSize: parent.height/2;
        }
    }

    function edgeDied(edge) {
        var i = edgeArray.indexOf(edge)
        if(i !== -1) {
            edgeArray.splice(i, 1)
        }
    }

    function kys() {
        var len = edgeArray.length
        for(var i = 0; i < len; ++i)
        {
            edgeArray[0].kys()
        }
        graph.nodeDied(nodeNumber)
        destroy();
    }

    MouseArea {
        visible: graph.mode === "Delete"
        anchors.fill: parent
        onClicked: parent.kys()
    }

    MouseArea {
        visible: graph.mode === "Move"
        anchors.fill: parent
        drag.target: parent
    }
}
