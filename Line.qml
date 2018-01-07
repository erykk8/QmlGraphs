import QtQuick 2.7

Rectangle {
    property int startX: 0
    property int startY: 0
    property int endX: 0
    property int endY: 0
    readonly property int dx: endX - startX
    readonly property int dy: endY - startY
    property int size: 1

    transformOrigin: Item.Left
    x: startX
    y: startY
    width: Math.sqrt(dx*dx + dy*dy)
    height: size
    radius: size
    color: 'black'
    rotation: Math.atan2(dy, dx)*180/Math.PI
}
