import QtQuick
import QtQuick.Controls
import "../global.js" as Global

Flickable {
  contentHeight: pane.height
  clip: true

  Pane {
    id: pane
    width: parent.width

    Column {
      width: Math.min(parent.width, Global.maxWidth)
      anchors.horizontalCenter: parent.horizontalCenter
      spacing: 16
    }
  }

  ScrollBar.vertical: ScrollBar {
    policy: ScrollBar.AsNeeded
  }
}