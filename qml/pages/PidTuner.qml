import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import SerialPort
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

      LabelHeading {
        text: qsTr("Save PID")
      }

      Pane 
      {
        Material.elevation: 2
        width: parent.width

        Button {
          text: qsTr("Save PID")
          Material.foreground: "white"
          Material.background: Material.accent
          enabled: SerialPort.isConnected
          onClicked: SerialPort.savePid()
        }
      }
    }
  }

  ScrollBar.vertical: ScrollBar {
    policy: ScrollBar.AsNeeded
  }
}