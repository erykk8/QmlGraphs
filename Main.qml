import QtQuick 2.7
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.2
import Qt.labs.platform 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "Graph.js" as Graph

ApplicationWindow {
    id: root
    width: 800
    height: 600
    visible: true
    title: "QmlGraphs"

    FileDialog {
        id: fileDialog
        folder: StandardPaths.writableLocation(StandardPaths.HomeLocation)
        onAccepted: fileMode === FileDialog.OpenFile ? graphArea.graph.loadFromFile(file) : graphArea.graph.saveToFile(file)
    }

    Action {
        id: nodeMode
        property string mode: "Node"
        text: "&Node"
        shortcut: mode[0]
        onTriggered: graphArea.mode = mode
    }

    Action {
        id: edgeMode
        property string mode: "Edge"
        text: "&Edge"
        shortcut: mode[0]
        onTriggered: graphArea.mode = mode
    }

    Action {
        id: moveMode
        property string mode: "Move"
        text: "&Move"
        shortcut: mode[0]
        onTriggered: graphArea.mode = mode
    }

    Action {
        id: deleteMode
        property string mode: "Delete"
        text: "&Delete"
        shortcut: mode[0]
        onTriggered: graphArea.mode = mode
    }


    menuBar: MenuBar {
        id: menuBar

        function openDialog() {
            fileDialog.fileMode = FileDialog.OpenFile
            fileDialog.title = "Open Graph"
            fileDialog.open()
        }

        function saveDialog() {
            fileDialog.fileMode = FileDialog.SaveFile
            fileDialog.title = "Choose Graph"
            fileDialog.open()
        }

        Menu {
            title: "File"
            MenuItem {
                action: Action {
                    text: "New"
                    shortcut: StandardKey.New
                    onTriggered: graphArea.graph.clear()
                }
            }

            MenuItem {
                action: Action {
                    text: "Open"
                    shortcut: StandardKey.Open
                    onTriggered: menuBar.openDialog()
                }
            }
            MenuItem {
                action: Action {
                    text: "Save"
                    shortcut: StandardKey.Save
                    onTriggered: menuBar.saveDialog()
                }
            }
            MenuItem {
                action: Action {
                    text: "Quit"
                    shortcut: StandardKey.Quit
                    onTriggered: Qt.quit()
                }
            }
        }

        Menu {
            title: "View"
            MenuItem {
                action: Action {
                    text: "Zoom In"
                    shortcut: StandardKey.ZoomIn
                    onTriggered: graphArea.adjustZoom(1.1)
                }
            }
            MenuItem {
                action: Action {
                    text: "Zoom Out"
                    shortcut: StandardKey.ZoomOut
                    onTriggered: graphArea.adjustZoom(0.9)
                }
            }
        }

    }

    toolBar: ToolBar {
        RowLayout {
            id: toolbarLayout
            anchors.verticalCenter: parent.verticalCenter
            Repeater {
                model: [nodeMode, edgeMode, moveMode, deleteMode]
                ToolButton {
                    anchors.top: parent.top

                    ColorOverlay {
                        anchors.fill: parent
                        source: parent
                        color: graphArea.mode === action.mode ? "#3200ff00" : "transparent"
                    }

                    action: modelData
                }
            }
        }
    }

    GraphArea {
        id: graphArea
        anchors.fill: parent
    }
}

