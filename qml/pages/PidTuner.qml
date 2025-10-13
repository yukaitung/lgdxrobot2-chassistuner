import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import "PidTuner"
import "../shared"
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

      LabelHeading {
        text: qsTr("PID Configuration")
      }

      PidConfigurationPane {
        width: parent.width
      }

      LabelHeading {
        text: qsTr("PID Test")
      }

      PidTestPane {
        width: parent.width
      }
    }
  }

  ScrollBar.vertical: ScrollBar {
    policy: ScrollBar.AsNeeded
  }
}