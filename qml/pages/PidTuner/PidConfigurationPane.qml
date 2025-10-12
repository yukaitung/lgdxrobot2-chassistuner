import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import RobotData
import SerialPort
import "../../shared"

Pane {
  Material.elevation: 2
  width: parent.width
  
  Column {
    width: parent.width
    spacing: 8
    
    // 1. PID
    PidTable {
      width: parent.width
      level: 0
    }

    PidTable {
      width: parent.width
      level: 1
    }

    PidTable {
      width: parent.width
      level: 2
    }

    // 2. Refresh
    Button {
      text: qsTr("Refresh")
      Material.foreground: "white"
      Material.background: Material.accent
      Layout.alignment: Qt.AlignRight
      enabled: SerialPort.isConnected
      onClicked: SerialPort.getPid()
    }

    // 3. Velocity setting
    RowLayout {
      width: parent.width
      spacing: 8

      LabelText {
        text: qsTr("Set Level Velocity")
        font.bold: true
        Layout.fillWidth: true
      }

      TextField {
        placeholderText: qsTr("Level 1")
        Layout.preferredWidth: 150
        Layout.preferredHeight: 48
      }

      TextField {
        placeholderText: qsTr("Level 2")
        Layout.preferredWidth: 150
        Layout.preferredHeight: 48
      }

      TextField {
        placeholderText: qsTr("Level 3")
        Layout.preferredWidth: 150
        Layout.preferredHeight: 48
      }

      Item {
        Layout.fillWidth: true
      }

      Button {
        text: qsTr("Send")
        Material.foreground: "white"
        Material.background: Material.accent
        Layout.alignment: Qt.AlignRight
        enabled: SerialPort.isConnected
      }
    }
  }
}